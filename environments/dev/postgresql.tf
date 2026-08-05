# name: Raul Pena (raul.pena@gmail.com)
# createAt: 2026-08-02T17:53:34-0300
# Description: Dev environment PostgreSQL RDS module composition.

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
