# name: Raul Pena (raul.pena@gmail.com)
# createAt: 2026-08-04T21:24:39-0300
# Description: Input variables for private PostgreSQL RDS instances.

variable "name_prefix" {
  description = "Prefix used for database resource names."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the database security group is created."
  type        = string
}

variable "data_subnet_ids" {
  description = "Private data subnet IDs where RDS can place database network interfaces."
  type        = map(string)

  validation {
    condition     = length(var.data_subnet_ids) >= 2
    error_message = "At least two data subnets are required for an RDS subnet group."
  }
}

variable "allowed_security_group_ids" {
  description = "Security group IDs allowed to connect to PostgreSQL."
  type        = list(string)

  validation {
    condition     = length(var.allowed_security_group_ids) > 0
    error_message = "At least one source security group must be allowed to connect to PostgreSQL."
  }
}

variable "database_name" {
  description = "Initial PostgreSQL database name."
  type        = string
  default     = "appdb"
}

variable "master_username" {
  description = "PostgreSQL master username."
  type        = string
  default     = "appadmin"
}

variable "engine_version" {
  description = "PostgreSQL major engine version."
  type        = string
  default     = "16"
}

variable "instance_class" {
  description = "RDS instance class."
  type        = string
}

variable "allocated_storage" {
  description = "Initial storage size in GiB."
  type        = number
}

variable "max_allocated_storage" {
  description = "Maximum storage size in GiB for autoscaling. Set to 0 to disable storage autoscaling."
  type        = number
  default     = 0
}

variable "storage_type" {
  description = "RDS storage type."
  type        = string
  default     = "gp3"
}

variable "multi_az" {
  description = "Whether to deploy a standby database instance in another Availability Zone."
  type        = bool
}

variable "backup_retention_period" {
  description = "Number of days to retain automated backups."
  type        = number
}

variable "deletion_protection" {
  description = "Whether deletion protection is enabled."
  type        = bool
}

variable "skip_final_snapshot" {
  description = "Whether to skip a final snapshot when deleting the DB instance."
  type        = bool
}

variable "performance_insights_enabled" {
  description = "Whether Performance Insights is enabled."
  type        = bool
  default     = false
}

variable "monitoring_interval" {
  description = "Enhanced Monitoring interval in seconds. Use 0 to disable."
  type        = number
  default     = 0
}
