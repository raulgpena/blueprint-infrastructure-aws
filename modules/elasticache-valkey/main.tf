# name: Raul Pena (raul.pena@gmail.com)
# createAt: 2026-08-08T11:29:25-0300
# Description: Private Amazon ElastiCache Valkey replication group, subnet group, and security group.

# Cache subnet group associating private data subnets for Valkey placement
resource "aws_elasticache_subnet_group" "this" {
  name        = "${var.name_prefix}-valkey"
  description = "Private data subnets for ${var.name_prefix} Valkey"
  subnet_ids  = values(var.data_subnet_ids)

  tags = {
    Name = "${var.name_prefix}-valkey"
  }
}

# Security group controlling ingress and egress for Valkey
resource "aws_security_group" "this" {
  name        = "${var.name_prefix}-valkey"
  description = "Allow Valkey access from approved private services"
  vpc_id      = var.vpc_id

  # Ingress rule dynamically created per approved application security group
  dynamic "ingress" {
    for_each = toset(var.allowed_security_group_ids)

    content {
      description     = "Valkey from services security group"
      from_port       = var.port
      to_port         = var.port
      protocol        = "tcp"
      security_groups = [ingress.value]
    }
  }

  # Allow all outbound traffic for cache response traffic and managed service operations
  egress {
    description = "Allow established outbound cache responses"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name_prefix}-valkey"
  }
}

# ElastiCache Valkey replication group for application cache workloads
resource "aws_elasticache_replication_group" "this" {
  replication_group_id = "${var.name_prefix}-valkey"
  description          = "Private Valkey cache for ${var.name_prefix}"

  # Engine and compute specifications
  engine         = "valkey"
  engine_version = var.engine_version
  node_type      = var.node_type
  port           = var.port

  # Cluster size and availability behavior
  num_cache_clusters         = var.num_cache_clusters
  automatic_failover_enabled = var.automatic_failover_enabled
  multi_az_enabled           = var.multi_az_enabled

  # Network and security placement
  subnet_group_name  = aws_elasticache_subnet_group.this.name
  security_group_ids = [aws_security_group.this.id]

  # Data protection and maintenance behavior
  at_rest_encryption_enabled = true
  transit_encryption_enabled = var.transit_encryption_enabled
  snapshot_retention_limit   = var.snapshot_retention_limit
  snapshot_window            = var.snapshot_window
  maintenance_window         = var.maintenance_window
  apply_immediately          = var.apply_immediately
  auto_minor_version_upgrade = var.auto_minor_version_upgrade

  tags = {
    Name = "${var.name_prefix}-valkey"
  }
}
