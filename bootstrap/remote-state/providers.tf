# name: Raul Pena (raul.pena@gmail.com)
# createAt: 2026-08-02T17:53:34-0300
# Description: AWS provider configuration and default tagging for the remote state bootstrap stack.

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = local.tags
  }
}
