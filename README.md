# Summary
Terraform project to setup static artifact storage on AWS

## Usage example
```
# terraform.tfvars
region              = "us-west-2"
project_name        = "Project"
environment         = "test"
root_domain_name    = "example.com"
vpc_cidr            = "10.10.1.0/24"
epam_cidr           = "192.168.1.0/24"
security_groups     = ["test-sg"]
s3_bucket_name      = "tf-static-artifactory-storage"
cert_body_path      = "./certs/example.crt.pem"
private_key_path    = "./certs/example.key.pem"
```
```
terraform plan -var-file="./terraform.tfvars"
terraform apply -var-file="./terraform.tfvars"
```
