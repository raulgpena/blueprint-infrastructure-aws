# name: Raul Pena (raul.pena@gmail.com)
# createAt: 2026-08-02T17:53:34-0300
# Description: Output values exported by the prod environment root module.

output "vpc_id" {
  description = "VPC ID."
  value       = module.networking.vpc_id
}

output "services_subnet_ids" {
  description = "Private services subnet IDs by Availability Zone."
  value       = module.networking.services_subnet_ids
}

output "data_subnet_ids" {
  description = "Private data subnet IDs by Availability Zone."
  value       = module.networking.data_subnet_ids
}

output "public_subnet_ids" {
  description = "Public subnet IDs by Availability Zone."
  value       = module.networking.public_subnet_ids
}

output "postgresql_endpoint" {
  description = "Private PostgreSQL RDS endpoint."
  value       = module.postgresql.db_instance_endpoint
}

output "postgresql_secret_arn" {
  description = "Secrets Manager ARN for the RDS-managed PostgreSQL master password."
  value       = module.postgresql.master_user_secret_arn
}
