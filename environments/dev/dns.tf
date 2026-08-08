# name: Raul Pena (raul.pena@gmail.com)
# createAt: 2026-08-08T10:25:30-0300
# Description: Dev environment optional Route 53 public hosted zone.

# Create public DNS zone
module "public_hosted_zone" {
  source = "../../modules/route53-public-zone"

  create        = var.create_public_hosted_zone
  domain_name   = var.public_hosted_zone_domain_name
  comment       = "Public DNS zone for ${local.name_prefix}"
  force_destroy = var.public_hosted_zone_force_destroy
}
