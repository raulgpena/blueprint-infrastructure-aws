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

# Export the private PostgreSQL RDS endpoint.
output "postgresql_endpoint" {
  description = "Private PostgreSQL RDS endpoint."
  value       = module.postgresql.db_instance_endpoint
}

# Export the RDS-managed PostgreSQL master password ARN.
output "postgresql_secret_arn" {
  description = "Secrets Manager ARN for the RDS-managed PostgreSQL master password."
  value       = module.postgresql.master_user_secret_arn
}

# Export the private SSM host ID used for database port forwarding.
output "database_access_instance_id" {
  description = "Private EC2 instance ID used for SSM database port forwarding."
  value       = try(module.database_access[0].instance_id, null)
}

# Export the SSM port-forward command for PostgreSQL access. It uses the private helper instance and the RDS private endpoint.
output "postgresql_port_forward_command" {
  description = "AWS CLI command that opens a local PostgreSQL tunnel through SSM."
  value       = try("aws ssm start-session --target ${module.database_access[0].instance_id} --document-name AWS-StartPortForwardingSessionToRemoteHost --parameters '{\"host\":[\"${module.postgresql.db_instance_address}\"],\"portNumber\":[\"5432\"],\"localPortNumber\":[\"5432\"]}'", null)
}

# S3 artifact repository bucket names output
output "artifact_repository_bucket_names" {
  description = "Private S3 artifact repository bucket names by repository type."
  value       = module.artifact_repositories.bucket_names
}

# S3 artifact repository URIs output
output "artifact_repository_uris" {
  description = "Private S3 artifact repository URIs by repository type."
  value       = module.artifact_repositories.repository_uris
}

# Route 53 hosted zone ID output
output "public_hosted_zone_id" {
  description = "Route 53 public hosted zone ID."
  value       = module.public_hosted_zone.zone_id
}

# Route 53 name servers output for external registrar configuration
output "public_hosted_zone_name_servers" {
  description = "Route 53 name servers to configure at the external domain registrar."
  value       = module.public_hosted_zone.name_servers
}
