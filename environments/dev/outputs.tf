# name: Raul Pena (raul.pena@gmail.com)
# createAt: 2026-08-02T17:53:34-0300
# Description: Output values exported by the dev environment root module.

# Export the ID of the created Virtual Private Cloud (VPC) for use by other modules or configurations.
output "vpc_id" {
  description = "VPC ID."
  value       = module.networking.vpc_id
}

# List of private services subnet IDs organized by Availability Zone where user workloads run.
output "services_subnet_ids" {
  description = "Private services subnet IDs by Availability Zone."
  value       = module.networking.services_subnet_ids
}

# List of private data subnet IDs organized by Availability Zone where backend data services run.
output "data_subnet_ids" {
  description = "Private data subnet IDs by Availability Zone."
  value       = module.networking.data_subnet_ids
}

# List of public subnet IDs organized by Availability Zone for resources that require internet access.
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
