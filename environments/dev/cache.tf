# name: Raul Pena (raul.pena@gmail.com)
# createAt: 2026-08-08T11:29:25-0300
# Description: Dev environment ElastiCache Valkey module composition.

# Create a private Valkey cache in the data subnet tier for dev application development.
module "valkey" {
  source = "../../modules/elasticache-valkey"

  name_prefix                = local.name_prefix
  vpc_id                     = module.networking.vpc_id
  data_subnet_ids            = module.networking.data_subnet_ids
  allowed_security_group_ids = [module.networking.services_security_group_id]

  engine_version             = var.valkey_engine_version
  node_type                  = var.valkey_node_type
  num_cache_clusters         = var.valkey_num_cache_clusters
  automatic_failover_enabled = var.valkey_automatic_failover_enabled
  multi_az_enabled           = var.valkey_multi_az_enabled
  snapshot_retention_limit   = var.valkey_snapshot_retention_limit
  snapshot_window            = var.valkey_snapshot_window
  maintenance_window         = var.valkey_maintenance_window
  apply_immediately          = var.valkey_apply_immediately
  transit_encryption_enabled = var.valkey_transit_encryption_enabled
  auto_minor_version_upgrade = var.valkey_auto_minor_version_upgrade
}
