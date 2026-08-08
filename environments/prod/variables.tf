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
