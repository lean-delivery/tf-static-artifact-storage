variable "region" {
  default     = "us-west-2"
  description = "AWS Region"
}
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

variable "security_groups" {
  type        = "list"
  default     = []
  description = "List of security groups ids"
}

variable "vpc_cidr" {
  default     = "0.0.0.0/16"
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
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
