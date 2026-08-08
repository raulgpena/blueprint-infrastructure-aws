# name: Raul Pena (raul.pena@gmail.com)
# createAt: 2026-08-08T11:29:25-0300
# Description: Output values exported by the reusable ElastiCache Valkey module.

# ElastiCache replication group identifier
output "replication_group_id" {
  description = "ElastiCache Valkey replication group ID."
  value       = aws_elasticache_replication_group.this.id
}

# Primary endpoint address for write and read traffic
output "primary_endpoint_address" {
  description = "Primary endpoint address for the Valkey replication group."
  value       = aws_elasticache_replication_group.this.primary_endpoint_address
}

# Reader endpoint address for read traffic when replicas exist
output "reader_endpoint_address" {
  description = "Reader endpoint address for the Valkey replication group."
  value       = aws_elasticache_replication_group.this.reader_endpoint_address
}

# TCP port exposed by the Valkey replication group
output "port" {
  description = "Valkey client connection port."
  value       = aws_elasticache_replication_group.this.port
}

# Security group ID protecting the Valkey replication group
output "security_group_id" {
  description = "ElastiCache Valkey security group ID."
  value       = aws_security_group.this.id
}

# Name of the cache subnet group used by the replication group
output "subnet_group_name" {
  description = "ElastiCache subnet group name."
  value       = aws_elasticache_subnet_group.this.name
}
