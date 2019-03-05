# Static artifact storage

[![License](https://img.shields.io/badge/license-Apache-green.svg?style=flat)](https://raw.githubusercontent.com/lean-delivery/tf-module-static-artifact-storage/master/LICENSE)
[![Build Status](https://travis-ci.org/lean-delivery/tf-module-static-artifact-storage.svg?branch=master)](https://travis-ci.org/lean-delivery/tf-module-static-artifact-storage)

## Description

Terraform project to setup static artifact storage on AWS

## Usage

### Conditional creation

```
module "static-artifact-storage" {
    source = "github.com/lean-delivery/tf-module-static-artifact-storage"
    
    region          = "us-west-2"
    project         = "Project"
    environment     = "test"
    root_domain     = "example.com"
    vpc_cidr        = "10.10.1.0/24"
    security_groups = []
    s3_bucket_name  = "tf-static-artifactory-storage"
    whitelist       = []
}
```

### Examples

* [Example folder](https://github.com/lean-delivery/tf-module-aws-core/tree/master/examples)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| region | AWS Region | string | `"us-west-2"` | yes |
| project | Project name is used to identify resources | string | `"project"` | no |
| environment | Environment name is used to identify resources | string | `"dev"` | no |
| root\_domain | Name of Route53 zone (if 'create_route53_zone' = True) | string | `"example.com"` | no |
| tags | Additional tags for resources | map | `{}` | no |
| security_groups | List of security groups ids | list | `[]` | no |
| vpc\_cidr | The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden | string | `"0.0.0.0/16"` | no |
| s3_bucket_name | S3 bucket name | string | `tf-static-artifact-storage` | no |
| whitelist | List of whitelist CIDRs | list | `[]` | no |
| acm_certificate_arn | ARN of certificate | string | `""` | no |
| price_class | Default price class | string | `"PriceClass_200"` | no|

## Outputs

| Name | Description |
|------|-------------|
| vpc_id | id of VPC |
| whitelist | List of whitelist CIDRs |

## Terraform versions

Terraform version 0.11.11 or newer is required for this module to work.

## Contributing

Thank you for your interest in contributing! Please refer to [CONTRIBUTING.md](https://github.com/lean-delivery/tf-module-static-artifact-storage/blob/master/CONTRIBUTING.md) for guidance.

## License

Apache2.0 Licensed. See [LICENSE](https://github.com/lean-delivery/tf-module-static-artifact-storage/tree/master/LICENSE) for full details.

## Authors

Lean Delivery Team <team@lean-delivery.com>