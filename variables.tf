variable "region" {}

variable "root_domain_name" {}

variable "project_name" {}

variable "environment" {}

variable "epam_cidr" {
  type = "list"
}

variable "security_groups" {
  type = "list"
}

variable "cert_body_path" {
  default = ""
}

variable "private_key_path" {
  default = ""
}

variable "vpc_id" {
    default = ""
}

variable "vpc_cidr" {}

variable "s3_bucket_name" {}

variable "whitelist" {
  type = "list"
}

variable "acm_certificate_arn" {
  default = ""
}
