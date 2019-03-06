output "vpc_id" {
  value = "${module.vpc.vpc_id}"
  description = "VPC id"
}

output "whitelist" {
  value = "${var.whitelist}"
  description = "List of whitelist CIDRs"
}
