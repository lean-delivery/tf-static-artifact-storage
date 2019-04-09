variable "project" {
  default     = "project"
  description = "Project name is used to identify resources"
}

variable "environment" {
  default     = "dev"
  description = "Environment name is used to identify resources"
}

variable "tags" {
  type        = "map"
  default     = {}
  description = "Additional tags for resources"
}

variable "root_domain" {
  default     = "example.com"
  description = "Name of Route53 zone (if 'create_route53_zone' = True)"
}

variable "s3_bucket_name" {
  default     = "tf-static-artifact-storage"
  description = "S3 bucket name"
}

variable "whitelist" {
  type        = "list"
  default     = []
  description = "List of whitelist CIDRs"
}

variable "acm_certificate_arn" {
  default     = ""
  description = "ARN of certificate"
}

variable "price_class" {
  default     = "PriceClass_200"
  description = "Default price class"
}
