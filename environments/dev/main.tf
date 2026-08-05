# name: Raul Pena (raul.pena@gmail.com)
# createAt: 2026-08-02T17:53:34-0300
# Description: Dev environment composition using local tags and the networking module.

# Fetch the list of active AWS Availability Zones in the region to distribute subnets.
data "aws_availability_zones" "available" {
  state = "available"
}

# Build the foundational VPC network, creating public, services, and data subnets across Availability Zones.
module "networking" {
  source = "../../modules/networking"

  name_prefix        = local.name_prefix
  vpc_cidr           = var.vpc_cidr
  availability_zones = slice(data.aws_availability_zones.available.names, 0, var.az_count)
  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = var.single_nat_gateway
  enable_s3_endpoint = var.enable_s3_endpoint
}

# Create a private PostgreSQL database in the data subnet tier for dev application development.
module "postgresql" {
  source = "../../modules/rds-postgresql"

  name_prefix                = local.name_prefix
  vpc_id                     = module.networking.vpc_id
  data_subnet_ids            = module.networking.data_subnet_ids
  allowed_security_group_ids = [module.networking.services_security_group_id]

  database_name                = var.rds_database_name
  instance_class               = var.rds_instance_class
  allocated_storage            = var.rds_allocated_storage
  max_allocated_storage        = var.rds_max_allocated_storage
  multi_az                     = var.rds_multi_az
  backup_retention_period      = var.rds_backup_retention_period
  deletion_protection          = var.rds_deletion_protection
  skip_final_snapshot          = var.rds_skip_final_snapshot
  performance_insights_enabled = var.rds_performance_insights_enabled
}

# Create a private SSM helper for developer port forwarding to private PostgreSQL.
module "database_access" {
  count  = var.enable_database_access_host ? 1 : 0
  source = "../../modules/ssm-port-forward-host"

  name_prefix = local.name_prefix
  vpc_id      = module.networking.vpc_id
  subnet_id   = values(module.networking.services_subnet_ids)[0]

  endpoint_subnet_ids                = [values(module.networking.services_subnet_ids)[0]]
  instance_security_group_ids        = [module.networking.services_security_group_id]
  endpoint_source_security_group_ids = [module.networking.services_security_group_id]
  instance_type                      = var.database_access_instance_type
  root_volume_size                   = var.database_access_root_volume_size
}
