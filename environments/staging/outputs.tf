# name: Raul Pena (raul.pena@gmail.com)
# createAt: 2026-08-02T17:53:34-0300
# Description: Output values exported by the staging environment root module.

# Export networking outputs.
output "vpc_id" {
  description = "VPC ID."
  value       = module.networking.vpc_id
}

# Export networking outputs.
output "services_subnet_ids" {
  description = "Private services subnet IDs by Availability Zone."
  value       = module.networking.services_subnet_ids
}

# Export networking outputs.
output "data_subnet_ids" {
  description = "Private data subnet IDs by Availability Zone."
  value       = module.networking.data_subnet_ids
}

# Export networking outputs.
output "public_subnet_ids" {
  description = "Public subnet IDs by Availability Zone."
  value       = module.networking.public_subnet_ids
}

# Export PostgreSQL outputs.
output "postgresql_endpoint" {
  description = "Private PostgreSQL RDS endpoint."
  value       = module.postgresql.db_instance_endpoint
}

# Export PostgreSQL outputs.
output "postgresql_secret_arn" {
  description = "Secrets Manager ARN for the RDS-managed PostgreSQL master password."
  value       = module.postgresql.master_user_secret_arn
}

# Export Valkey outputs.
output "valkey_primary_endpoint_address" {
  description = "Private Valkey primary endpoint address."
  value       = module.valkey.primary_endpoint_address
}

# Export Valkey outputs.
output "valkey_reader_endpoint_address" {
  description = "Private Valkey reader endpoint address."
  value       = module.valkey.reader_endpoint_address
}

# Export Valkey outputs.
output "valkey_port" {
  description = "Valkey client connection port."
  value       = module.valkey.port
}
