# name: Raul Pena (raul.pena@gmail.com)
# createAt: 2026-08-02T17:53:34-0300
# Description: Input variables for configuring the staging environment root module.

# Input variable for AWS region
variable "aws_region" {
  description = "AWS region."
  type        = string
}

# Input variable for project name
variable "project" {
  description = "Project or application name."
  type        = string
}

# Input variable for environment name
variable "environment" {
  description = "Environment name."
  type        = string
  default     = "staging"

  validation {
    condition     = var.environment == "staging"
    error_message = "This root module is dedicated to the staging environment."
  }
}

# Input variable for owner
variable "owner" {
  description = "Team or person accountable for these resources."
  type        = string
}

# Input variable for cost center
variable "cost_center" {
  description = "Cost allocation identifier."
  type        = string
}

# Input variable for data classification
variable "data_classification" {
  description = "Data classification tag value."
  type        = string
  default     = "internal"
}

# Input variable for additional tags
variable "additional_tags" {
  description = "Additional tags merged with required tags."
  type        = map(string)
  default     = {}
}

# Input variable for VPC CIDR block
variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
}

# Input variable for number of Availability Zones
variable "az_count" {
  description = "Number of Availability Zones to use."
  type        = number
  default     = 2

  validation {
    condition     = var.az_count >= 2 && var.az_count <= 4
    error_message = "AZ count must be between 2 and 4."
  }
}

# Input variable for enabling NAT Gateway
variable "enable_nat_gateway" {
  description = "Whether private services subnets should route internet egress through NAT Gateway."
  type        = bool
  default     = true
}

# Input variable for single NAT Gateway
variable "single_nat_gateway" {
  description = "Use one NAT Gateway instead of one per Availability Zone."
  type        = bool
  default     = true
}

# Input variable for enabling S3 endpoint
variable "enable_s3_endpoint" {
  description = "Create a gateway VPC endpoint for Amazon S3."
  type        = bool
  default     = true
}

# Input variable for RDS database name
variable "rds_database_name" {
  description = "Initial PostgreSQL database name."
  type        = string
  default     = "appdb"
}

# Input variable for RDS instance class
variable "rds_instance_class" {
  description = "RDS PostgreSQL instance class."
  type        = string
  default     = "db.t4g.small"
}

# Input variable for RDS allocated storage
variable "rds_allocated_storage" {
  description = "Initial RDS PostgreSQL storage size in GiB."
  type        = number
  default     = 30
}

# Input variable for RDS max allocated storage
variable "rds_max_allocated_storage" {
  description = "Maximum RDS PostgreSQL storage size in GiB for autoscaling."
  type        = number
  default     = 200
}

# Input variable for RDS multi AZ
variable "rds_multi_az" {
  description = "Whether RDS PostgreSQL is deployed as Multi-AZ."
  type        = bool
  default     = false
}

# Input variable for RDS backup retention period
variable "rds_backup_retention_period" {
  description = "Number of days to retain RDS automated backups."
  type        = number
  default     = 3
}

# Input variable for RDS deletion protection
variable "rds_deletion_protection" {
  description = "Whether RDS deletion protection is enabled."
  type        = bool
  default     = false
}

# Input variable for RDS skip final snapshot
variable "rds_skip_final_snapshot" {
  description = "Whether to skip a final RDS snapshot when deleting the DB instance."
  type        = bool
  default     = true
}

# Input variable for RDS performance insights enabled
variable "rds_performance_insights_enabled" {
  description = "Whether RDS Performance Insights is enabled."
  type        = bool
  default     = false
}
