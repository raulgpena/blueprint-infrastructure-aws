# name: Raul Pena (raul.pena@gmail.com)
# createAt: 2026-08-04T21:24:39-0300
# Description: Input variables for private PostgreSQL RDS instances.

# Prefix for naming database resources
variable "name_prefix" {
  description = "Prefix used for database resource names."
  type        = string
}

# VPC ID where the RDS security group and resources reside
variable "vpc_id" {
  description = "VPC ID where the database security group is created."
  type        = string
}

# Map of data subnet IDs across multiple Availability Zones
variable "data_subnet_ids" {
  description = "Private data subnet IDs where RDS can place database network interfaces."
  type        = map(string)

  # Enforce minimum of two subnets for high-availability subnet group
  validation {
    condition     = length(var.data_subnet_ids) >= 2
    error_message = "At least two data subnets are required for an RDS subnet group."
  }
}

# Application security group IDs permitted to connect on port 5432
variable "allowed_security_group_ids" {
  description = "Security group IDs allowed to connect to PostgreSQL."
  type        = list(string)

  # Enforce at least one authorized client security group
  validation {
    condition     = length(var.allowed_security_group_ids) > 0
    error_message = "At least one source security group must be allowed to connect to PostgreSQL."
  }
}

# Initial database name to create upon instance launch
variable "database_name" {
  description = "Initial PostgreSQL database name."
  type        = string
  default     = "appdb"
}

# Master administrator username for PostgreSQL
variable "master_username" {
  description = "PostgreSQL master username."
  type        = string
  default     = "appadmin"
}

# Target major version of PostgreSQL engine
variable "engine_version" {
  description = "PostgreSQL major engine version."
  type        = string
  default     = "16"
}

# Compute and memory sizing class for the DB instance
variable "instance_class" {
  description = "RDS instance class."
  type        = string
}

# Allocated initial EBS storage size in GiB
variable "allocated_storage" {
  description = "Initial storage size in GiB."
  type        = number
}

# Upper threshold in GiB for storage autoscaling (0 disables autoscaling)
variable "max_allocated_storage" {
  description = "Maximum storage size in GiB for autoscaling. Set to 0 to disable storage autoscaling."
  type        = number
  default     = 0
}

# EBS volume storage type
variable "storage_type" {
  description = "RDS storage type."
  type        = string
  default     = "gp3"
}

# Toggle Multi-AZ synchronous standby deployment for failover support
variable "multi_az" {
  description = "Whether to deploy a standby database instance in another Availability Zone."
  type        = bool
}

# Retention window in days for automated database snapshots
variable "backup_retention_period" {
  description = "Number of days to retain automated backups."
  type        = number
}

# Guardrail to prevent accidental database deletion via Terraform or AWS API
variable "deletion_protection" {
  description = "Whether deletion protection is enabled."
  type        = bool
}

# Toggle final snapshot creation prior to instance termination
variable "skip_final_snapshot" {
  description = "Whether to skip a final snapshot when deleting the DB instance."
  type        = bool
}

# Toggle Performance Insights for query performance diagnostics
variable "performance_insights_enabled" {
  description = "Whether Performance Insights is enabled."
  type        = bool
  default     = false
}

# Enhanced Monitoring collection frequency in seconds (0 disables)
variable "monitoring_interval" {
  description = "Enhanced Monitoring interval in seconds. Use 0 to disable."
  type        = number
  default     = 0
}
