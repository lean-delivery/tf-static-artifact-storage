variable "region" {}

variable "root_domain_name" {}

variable "project_name" {}

variable "environment" {}

variable "epam_cidr" {}

variable "security_groups" {
  type = "list"
}

variable "cert_body_path" {
}

variable "private_key_path" {
}

variable "vpc_id" {
    default = ""
}

variable "vpc_cidr" {}

variable "s3_bucket_name" {}
