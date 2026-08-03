# name: Raul Pena (raul.pena@gmail.com)
# createAt: 2026-08-02T17:53:34-0300
# Description: Prod environment composition using local tags and the networking module.

data "aws_availability_zones" "available" {
  state = "available"
}

module "networking" {
  source = "../../modules/networking"

  name_prefix        = local.name_prefix
  vpc_cidr           = var.vpc_cidr
  availability_zones = slice(data.aws_availability_zones.available.names, 0, var.az_count)
  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = var.single_nat_gateway
  enable_s3_endpoint = var.enable_s3_endpoint
}
