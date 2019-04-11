locals {
  default_tags = {
    Project     = "${var.project}"
    Environment = "${var.environment}"
  }

  acm_certificate_arn = "${var.acm_certificate_arn == "" ? module.aws-cert.acm_certificate_arn : var.acm_certificate_arn}"
  distribution_label  = "${var.project}-${var.environment}-distribution_label"
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "${local.distribution_label}"
}

data "aws_iam_policy_document" "origin" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::$${bucket_name}/"]

    principals {
      type        = "AWS"
      identifiers = ["${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}"]
    }
  }

  statement {
    actions   = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::$${bucket_name}"]

    principals {
      type        = "AWS"
      identifiers = ["${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}"]
    }
  }
}

data "template_file" "default" {
  template = "${data.aws_iam_policy_document.origin.json}"

  vars {
    origin_path = "/"
    bucket_name = "${var.s3_bucket_name}"
  }
}

resource "aws_s3_bucket" "origin" {
  bucket        = "${var.s3_bucket_name}"
  acl           = "private"
  force_destroy = true

  logging {
    target_bucket = "${var.s3_bucket_name}"
    target_prefix = "log/"
  }

  tags = "${merge(local.default_tags, var.tags)}"
}

resource "aws_s3_bucket_policy" "default" {
  bucket = "${aws_s3_bucket.origin.id}"
  policy = "${data.template_file.default.rendered}"
}

module "aws-cert" {
  source = "github.com/lean-delivery/tf-module-aws-acm"

  module_enabled = "${var.acm_certificate_arn == "" ? true : false}"
  domain         = "${var.root_domain}"
  zone_id        = "${aws_cloudfront_distribution.default.hosted_zone_id}"

  tags = "${merge(local.default_tags, var.tags)}"
}

resource "aws_cloudfront_distribution" "default" {
  enabled      = true
  price_class  = "${var.price_class}"
  http_version = "http2"
  aliases      = ["${var.root_domain}", "www.${var.root_domain}"]
  web_acl_id   = "${aws_waf_web_acl.whitelist_waf_acl.id}"
  depends_on   = ["aws_s3_bucket.origin"]

  origin {
    origin_id   = "${local.distribution_label}"
    domain_name = "${aws_s3_bucket.origin.bucket_regional_domain_name}"

    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
    }

    custom_origin_config {
      http_port              = "80"
      https_port             = "443"
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }

  default_cache_behavior {
    allowed_methods  = ["HEAD", "GET", "OPTIONS"]
    cached_methods   = ["HEAD", "GET", "OPTIONS"]
    target_origin_id = "${local.distribution_label}"

    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    viewer_protocol_policy = "redirect-to-https"
    compress               = true

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = "${local.acm_certificate_arn}"
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1"

    cloudfront_default_certificate = "${var.acm_certificate_arn == "" ? true : false}"
  }

  logging_config {
    include_cookies = false
    bucket          = "${var.s3_bucket_name}"
    prefix          = "cflog/"
  }

  tags = "${merge(local.default_tags, var.tags)}"
}

resource "aws_waf_ipset" "whitelist_ipset" {
  name = "whitelist_ipset"

  ip_set_descriptors = "${var.whitelist}"
}

resource "aws_waf_rule" "whitelist_wafrule" {
  depends_on  = ["aws_waf_ipset.whitelist_ipset"]
  name        = "whitelist_wafrule"
  metric_name = "WhitelistWafRule"

  predicates {
    data_id = "${aws_waf_ipset.whitelist_ipset.id}"
    negated = false
    type    = "IPMatch"
  }
}

resource "aws_waf_web_acl" "whitelist_waf_acl" {
  depends_on  = ["aws_waf_ipset.whitelist_ipset", "aws_waf_rule.whitelist_wafrule"]
  name        = "whitelist_waf_acl"
  metric_name = "WhitelistWebACL"

  default_action {
    type = "BLOCK"
  }

  rules {
    action {
      type = "ALLOW"
    }

    priority = 1
    rule_id  = "${aws_waf_rule.whitelist_wafrule.id}"
    type     = "REGULAR"
  }
}
