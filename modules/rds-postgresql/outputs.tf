# name: Raul Pena (raul.pena@gmail.com)
# createAt: 2026-08-04T21:24:39-0300
# Description: Output values exported by the reusable PostgreSQL RDS module.

# RDS DB instance identifier
output "db_instance_identifier" {
  description = "RDS DB instance identifier."
  value       = aws_db_instance.this.identifier
}

# Connection endpoint (host:port) for the database
output "db_instance_endpoint" {
  description = "RDS DB instance endpoint."
  value       = aws_db_instance.this.endpoint
}

# Hostname address of the RDS instance
output "db_instance_address" {
  description = "RDS DB instance address."
  value       = aws_db_instance.this.address
}

# Port on which the database accepts connections
output "db_instance_port" {
  description = "RDS DB instance port."
  value       = aws_db_instance.this.port
}

# Security group ID protecting the RDS instance
output "db_security_group_id" {
  description = "RDS security group ID."
  value       = aws_security_group.this.id
}

# Name of the DB subnet group used by the instance
output "db_subnet_group_name" {
  description = "RDS DB subnet group name."
  value       = aws_db_subnet_group.this.name
}

# ARN of the AWS Secrets Manager secret storing the managed master password
output "master_user_secret_arn" {
  description = "Secrets Manager ARN for the RDS-managed master password."
  value       = try(aws_db_instance.this.master_user_secret[0].secret_arn, null)
}
