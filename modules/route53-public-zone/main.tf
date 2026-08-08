# name: Raul Pena (raul.pena@gmail.com)
# createAt: 2026-08-08T10:25:30-0300
# Description: Optional Route 53 public hosted zone for externally registered domains.

locals {
  normalized_domain_name = trimsuffix(var.domain_name, ".")
}

resource "aws_route53_zone" "this" {
  count = var.create ? 1 : 0

  name          = local.normalized_domain_name
  comment       = var.comment
  force_destroy = var.force_destroy

  lifecycle {
    precondition {
      condition     = !var.create || local.normalized_domain_name != ""
      error_message = "domain_name is required when create is true."
    }
  }

  tags = {
    Name = local.normalized_domain_name
  }
}
