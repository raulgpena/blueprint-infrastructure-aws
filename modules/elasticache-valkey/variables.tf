# name: Raul Pena (raul.pena@gmail.com)
# createAt: 2026-08-08T11:29:25-0300
# Description: Input variables for private Amazon ElastiCache Valkey replication groups.

# Prefix for naming cache resources
variable "name_prefix" {
  description = "Prefix used for cache resource names."
  type        = string
}

# VPC ID where the cache security group and resources reside
variable "vpc_id" {
  description = "VPC ID where the cache security group is created."
  type        = string
}

# Map of data subnet IDs across multiple Availability Zones
variable "data_subnet_ids" {
  description = "Private data subnet IDs where ElastiCache can place cache nodes."
  type        = map(string)

  # Enforce minimum of two subnets for resilient subnet group placement
  validation {
    condition     = length(var.data_subnet_ids) >= 2
    error_message = "At least two data subnets are required for an ElastiCache subnet group."
  }
}

# Application security group IDs permitted to connect on the Valkey port
variable "allowed_security_group_ids" {
  description = "Security group IDs allowed to connect to Valkey."
  type        = list(string)

  # Enforce at least one authorized client security group
  validation {
    condition     = length(var.allowed_security_group_ids) > 0
    error_message = "At least one source security group must be allowed to connect to Valkey."
  }
}

# Target Valkey engine version
variable "engine_version" {
  description = "Valkey engine version."
  type        = string
  default     = "7.2"
}

# Compute and memory sizing class for each cache node
variable "node_type" {
  description = "ElastiCache node type."
  type        = string
}

# Number of cache nodes in the replication group
variable "num_cache_clusters" {
  description = "Number of cache nodes in the Valkey replication group."
  type        = number

  # At least one node is required for every replication group
  validation {
    condition     = var.num_cache_clusters >= 1
    error_message = "num_cache_clusters must be at least 1."
  }
}

# Toggle automatic failover for replicated cache groups
variable "automatic_failover_enabled" {
  description = "Whether automatic failover is enabled for the Valkey replication group."
  type        = bool

  # AWS requires more than one cache node when automatic failover is enabled
  validation {
    condition     = !var.automatic_failover_enabled || var.num_cache_clusters >= 2
    error_message = "automatic_failover_enabled requires num_cache_clusters to be at least 2."
  }
}

# Toggle Multi-AZ placement for failover-aware cache groups
variable "multi_az_enabled" {
  description = "Whether Multi-AZ is enabled for the Valkey replication group."
  type        = bool

  # Multi-AZ is useful only when automatic failover is also enabled
  validation {
    condition     = !var.multi_az_enabled || var.automatic_failover_enabled
    error_message = "multi_az_enabled requires automatic_failover_enabled to be true."
  }
}

# TCP port used by Valkey clients
variable "port" {
  description = "TCP port for Valkey client connections."
  type        = number
  default     = 6379
}

# Retention window in days for automated cache snapshots
variable "snapshot_retention_limit" {
  description = "Number of days to retain automated ElastiCache snapshots."
  type        = number
  default     = 1
}

# Daily time range when ElastiCache creates snapshots
variable "snapshot_window" {
  description = "Daily UTC time range when ElastiCache creates snapshots."
  type        = string
  default     = "03:00-04:00"
}

# Weekly time range when ElastiCache can perform maintenance
variable "maintenance_window" {
  description = "Weekly UTC time range when ElastiCache can perform maintenance."
  type        = string
  default     = "sun:04:00-sun:05:00"
}

# Toggle immediate application of eligible cache changes
variable "apply_immediately" {
  description = "Whether eligible cache changes are applied immediately instead of during the maintenance window."
  type        = bool
  default     = false
}

# Toggle automatic minor version upgrades
variable "auto_minor_version_upgrade" {
  description = "Whether ElastiCache can automatically apply minor engine version upgrades."
  type        = bool
  default     = true
}

# Toggle in-transit encryption for client connections
variable "transit_encryption_enabled" {
  description = "Whether in-transit encryption is enabled for Valkey client connections."
  type        = bool
  default     = true
}
