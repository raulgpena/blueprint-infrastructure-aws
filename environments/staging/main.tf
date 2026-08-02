# name: Raul Pena (raul.pena@gmail.com)
# createAt: 2026-08-02T17:53:34-0300
# Description: Staging environment composition using shared tags, networking, and KMS modules.

data "aws_availability_zones" "available" {
  state = "available"
}

module "tags" {
  source = "../../modules/tags"

  project             = var.project
  environment         = var.environment
  owner               = var.owner
  cost_center         = var.cost_center
  data_classification = var.data_classification
  additional_tags     = var.additional_tags
}

module "networking" {
  source = "../../modules/networking"

  name_prefix        = module.tags.name_prefix
  vpc_cidr           = var.vpc_cidr
  availability_zones = slice(data.aws_availability_zones.available.names, 0, var.az_count)
  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = var.single_nat_gateway
  enable_s3_endpoint = var.enable_s3_endpoint
  tags               = module.tags.tags
}

module "workload_kms" {
  source = "../../modules/kms"

  alias_name  = "${module.tags.name_prefix}-workload"
  description = "Default workload KMS key for ${module.tags.name_prefix}"
  tags        = module.tags.tags
}
