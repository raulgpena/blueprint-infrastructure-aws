# name: Raul Pena (raul.pena@gmail.com)
# createAt: 2026-08-08T10:25:30-0300
# Description: Terraform and AWS provider version constraints for the reusable Route 53 public hosted zone module.

terraform {
  required_version = ">= 1.10.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.80.0"
    }
  }
}
