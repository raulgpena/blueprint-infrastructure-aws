# name: Raul Pena (raul.pena@gmail.com)
# createAt: 2026-08-04T21:24:39-0300
# Description: Output values exported by the reusable PostgreSQL RDS module.

output "db_instance_identifier" {
  description = "RDS DB instance identifier."
  value       = aws_db_instance.this.identifier
}

output "db_instance_endpoint" {
  description = "RDS DB instance endpoint."
  value       = aws_db_instance.this.endpoint
}

output "db_instance_address" {
  description = "RDS DB instance address."
  value       = aws_db_instance.this.address
}

output "db_instance_port" {
  description = "RDS DB instance port."
  value       = aws_db_instance.this.port
}

output "db_security_group_id" {
  description = "RDS security group ID."
  value       = aws_security_group.this.id
}

output "db_subnet_group_name" {
  description = "RDS DB subnet group name."
  value       = aws_db_subnet_group.this.name
}

output "master_user_secret_arn" {
  description = "Secrets Manager ARN for the RDS-managed master password."
  value       = try(aws_db_instance.this.master_user_secret[0].secret_arn, null)
}
