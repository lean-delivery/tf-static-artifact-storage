output "vpc_id" {
  value = "${local.vpc_id}"
}

output "website" {
    value = "${var.root_domain_name}"
}

output "epam_cidr" {
    value = "${var.epam_cidr}"
}