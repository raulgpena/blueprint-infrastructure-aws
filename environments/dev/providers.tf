# name: Raul Pena (raul.pena@gmail.com)
# createAt: 2026-08-02T17:53:34-0300
# Description: AWS provider configuration and default tagging for the dev environment.

# Terraform configuration
provider "aws" {

  # AWS region
  region = var.aws_region

  # Default tags to apply to all resources
  default_tags {
    tags = local.tags
  }
}
