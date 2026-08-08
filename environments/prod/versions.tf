# name: Raul Pena (raul.pena@gmail.com)
# createAt: 2026-08-02T17:53:34-0300
# Description: Terraform backend and provider version constraints for the prod environment root.

# Terraform version constraints
terraform {

  # Use latest stable version
  required_version = ">= 1.10.0, < 2.0.0"

  # Remote state configuration for S3 backend.
  # See: https://www.terraform.io/language/settings/backends/s3
  backend "s3" {}

  # AWS provider version constraints
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.80.0"
    }
  }
}
