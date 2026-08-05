# name: Raul Pena (raul.pena@gmail.com)
# createAt: 2026-08-02T17:53:34-0300
# Description: Dev environment private SSM database access module composition.

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
