# name: Raul Pena (raul.pena@gmail.com)
# createAt: 2026-08-02T17:53:34-0300
# Description: Output values exported by the prod environment root module.

# VPC ID output
output "vpc_id" {
  description = "VPC ID."
  value       = module.networking.vpc_id
}

# Private services subnet IDs output
output "services_subnet_ids" {
  description = "Private services subnet IDs by Availability Zone."
  value       = module.networking.services_subnet_ids
}

# Private data subnet IDs output
output "data_subnet_ids" {
  description = "Private data subnet IDs by Availability Zone."
  value       = module.networking.data_subnet_ids
}

# Public subnet IDs output
output "public_subnet_ids" {
  description = "Public subnet IDs by Availability Zone."
  value       = module.networking.public_subnet_ids
}

# Private PostgreSQL RDS endpoint output
output "postgresql_endpoint" {
  description = "Private PostgreSQL RDS endpoint."
  value       = module.postgresql.db_instance_endpoint
}

# Secrets Manager ARN for the RDS-managed PostgreSQL master password output
output "postgresql_secret_arn" {
  description = "Secrets Manager ARN for the RDS-managed PostgreSQL master password."
  value       = module.postgresql.master_user_secret_arn
}

# Private Valkey primary endpoint output
output "valkey_primary_endpoint_address" {
  description = "Private Valkey primary endpoint address."
  value       = module.valkey.primary_endpoint_address
}

# Private Valkey reader endpoint output
output "valkey_reader_endpoint_address" {
  description = "Private Valkey reader endpoint address."
  value       = module.valkey.reader_endpoint_address
}

# Valkey client connection port output
output "valkey_port" {
  description = "Valkey client connection port."
  value       = module.valkey.port
}
