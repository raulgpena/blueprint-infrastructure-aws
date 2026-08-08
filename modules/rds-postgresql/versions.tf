# name: Raul Pena (raul.pena@gmail.com)
# createAt: 2026-08-04T21:24:39-0300
# Description: Terraform and AWS provider version constraints for the reusable PostgreSQL RDS module.

# Terraform settings and version constraints
terraform {
  # Minimum and maximum supported Terraform CLI version
  required_version = ">= 1.10.0, < 2.0.0"

  # Required providers and version constraints
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.80.0"
    }
  }
}
