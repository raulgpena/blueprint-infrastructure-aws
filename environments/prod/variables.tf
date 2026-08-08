# name: Raul Pena (raul.pena@gmail.com)
# createAt: 2026-08-02T17:53:34-0300
# Description: Input variables for configuring the prod environment root module.

# AWS region
variable "aws_region" {
  description = "AWS region."
  type        = string
}

# Project name
variable "project" {
  description = "Project or application name."
  type        = string
}

# Environment name
variable "environment" {
  description = "Environment name."
  type        = string
  default     = "prod"

  validation {
    condition     = var.environment == "prod"
    error_message = "This root module is dedicated to the prod environment."
  }
}

# Owner
variable "owner" {
  description = "Team or person accountable for these resources."
  type        = string
}

# Cost center
variable "cost_center" {
  description = "Cost allocation identifier."
  type        = string
}

# Data classification
variable "data_classification" {
  description = "Data classification tag value."
  type        = string
  default     = "confidential"
}

# Additional tags
variable "additional_tags" {
  description = "Additional tags merged with required tags."
  type        = map(string)
  default     = {}
}

# VPC CIDR
variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
}

# Number of Availability Zones
variable "az_count" {
  description = "Number of Availability Zones to use."
  type        = number
  default     = 3

  validation {
    condition     = var.az_count >= 3 && var.az_count <= 4
    error_message = "Production AZ count must be between 3 and 4."
  }
}

# Enable NAT Gateway
variable "enable_nat_gateway" {
  description = "Whether private services subnets should route internet egress through NAT Gateway."
  type        = bool
  default     = true
}

# Single NAT Gateway
variable "single_nat_gateway" {
  description = "Use one NAT Gateway instead of one per Availability Zone."
  type        = bool
  default     = false
}

# Enable S3 Endpoint
variable "enable_s3_endpoint" {
  description = "Create a gateway VPC endpoint for Amazon S3."
  type        = bool
  default     = true
}

# RDS PostgreSQL database name
variable "rds_database_name" {
  description = "Initial PostgreSQL database name."
  type        = string
  default     = "appdb"
}

# RDS PostgreSQL instance class
variable "rds_instance_class" {
  description = "RDS PostgreSQL instance class."
  type        = string
  default     = "db.t4g.medium"
}

# RDS PostgreSQL allocated storage
variable "rds_allocated_storage" {
  description = "Initial RDS PostgreSQL storage size in GiB."
  type        = number
  default     = 50
}

# RDS PostgreSQL max allocated storage
variable "rds_max_allocated_storage" {
  description = "Maximum RDS PostgreSQL storage size in GiB for autoscaling."
  type        = number
  default     = 500
}

# RDS PostgreSQL multi-AZ
variable "rds_multi_az" {
  description = "Whether RDS PostgreSQL is deployed as Multi-AZ."
  type        = bool
  default     = true
}

# RDS PostgreSQL backup retention period
variable "rds_backup_retention_period" {
  description = "Number of days to retain RDS automated backups."
  type        = number
  default     = 7
}

# RDS PostgreSQL deletion protection
variable "rds_deletion_protection" {
  description = "Whether RDS deletion protection is enabled."
  type        = bool
  default     = true
}

# RDS PostgreSQL skip final snapshot
variable "rds_skip_final_snapshot" {
  description = "Whether to skip a final RDS snapshot when deleting the DB instance."
  type        = bool
  default     = false
}

# RDS Performance Insights enabled
variable "rds_performance_insights_enabled" {
  description = "Whether RDS Performance Insights is enabled."
  type        = bool
  default     = true
}

# ElastiCache Valkey engine version
variable "valkey_engine_version" {
  description = "Valkey engine version."
  type        = string
  default     = "7.2"
}

# ElastiCache Valkey node type
variable "valkey_node_type" {
  description = "ElastiCache Valkey node type."
  type        = string
  default     = "cache.t4g.medium"
}

# ElastiCache Valkey cache node count
variable "valkey_num_cache_clusters" {
  description = "Number of cache nodes in the Valkey replication group."
  type        = number
  default     = 2
}

# ElastiCache Valkey automatic failover
variable "valkey_automatic_failover_enabled" {
  description = "Whether automatic failover is enabled for Valkey."
  type        = bool
  default     = true
}

# ElastiCache Valkey Multi-AZ
variable "valkey_multi_az_enabled" {
  description = "Whether Multi-AZ is enabled for Valkey."
  type        = bool
  default     = true
}

# ElastiCache Valkey snapshot retention
variable "valkey_snapshot_retention_limit" {
  description = "Number of days to retain automated Valkey snapshots."
  type        = number
  default     = 7
}

# ElastiCache Valkey snapshot window
variable "valkey_snapshot_window" {
  description = "Daily UTC time range when ElastiCache creates Valkey snapshots."
  type        = string
  default     = "03:00-04:00"
}

# ElastiCache Valkey maintenance window
variable "valkey_maintenance_window" {
  description = "Weekly UTC time range when ElastiCache can perform Valkey maintenance."
  type        = string
  default     = "sun:04:00-sun:05:00"
}

# ElastiCache Valkey apply behavior
variable "valkey_apply_immediately" {
  description = "Whether eligible Valkey changes are applied immediately."
  type        = bool
  default     = false
}

# ElastiCache Valkey in-transit encryption
variable "valkey_transit_encryption_enabled" {
  description = "Whether in-transit encryption is enabled for Valkey client connections."
  type        = bool
  default     = true
}

# ElastiCache Valkey minor version upgrades
variable "valkey_auto_minor_version_upgrade" {
  description = "Whether ElastiCache can automatically apply minor Valkey version upgrades."
  type        = bool
  default     = true
}
