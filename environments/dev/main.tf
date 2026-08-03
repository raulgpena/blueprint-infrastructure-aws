# name: Raul Pena (raul.pena@gmail.com)
# createAt: 2026-08-02T17:53:34-0300
# Description: Dev environment composition using shared tags and networking modules.

# Fetch the list of active AWS Availability Zones in the region to distribute subnets.
data "aws_availability_zones" "available" {
  state = "available"
}

# Generate consistent resource tags and a unified name prefix based on project variables.
module "tags" {
  source = "../../modules/tags"

  project             = var.project
  environment         = var.environment
  owner               = var.owner
  cost_center         = var.cost_center
  data_classification = var.data_classification
  additional_tags     = var.additional_tags
}

# Build the foundational VPC network, creating public/private subnets across the availability zones.
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
