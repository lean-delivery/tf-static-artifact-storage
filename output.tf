output "vpc_id" {
  value = "${module.vpc.vpc_id}"
}

output "whitelist" {
  value = "${var.whitelist}"
}