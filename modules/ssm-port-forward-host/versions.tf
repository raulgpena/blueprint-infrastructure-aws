# name: Raul Pena (raul.pena@gmail.com)
# createAt: 2026-08-04T21:50:02-0300
# Description: Terraform and AWS provider version constraints for the reusable SSM port-forwarding host module.

terraform {
  required_version = ">= 1.10.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.80.0"
    }
  }
}
