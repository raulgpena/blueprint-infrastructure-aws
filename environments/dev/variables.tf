# name: Raul Pena (raul.pena@gmail.com)
# createAt: 2026-08-02T17:53:34-0300
# Description: Input variables for configuring the dev environment root module.

# The target AWS region where S3, DynamoDB, and other environment resources will be deployed.
variable "aws_region" {
  description = "AWS region."
  type        = string
}

# The name of the project or application, used for naming prefix generation.
variable "project" {
  description = "Project or application name."
  type        = string
}

# The target deployment environment. Must be set to "dev".
variable "environment" {
  description = "Environment name."
  type        = string
  default     = "dev"

  validation {
    condition     = var.environment == "dev"
    error_message = "This root module is dedicated to the dev environment."
  }
}

# The owner/team accountable for maintaining and operating these resources.
variable "owner" {
  description = "Team or person accountable for these resources."
  type        = string
}

# Cost center identifier for resource tagging, budgeting, and cost allocation.
variable "cost_center" {
  description = "Cost allocation identifier."
  type        = string
}

# Security classification of the data stored (e.g. public, internal, confidential). Defaults to "internal".
variable "data_classification" {
  description = "Data classification tag value."
  type        = string
  default     = "internal"
}

# Optional extra resource tags that will be merged with the standard default tags.
variable "additional_tags" {
  description = "Additional tags merged with required tags."
  type        = map(string)
  default     = {}
}

# The IP range CIDR block for the Virtual Private Cloud (VPC) network.
variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
}

# The number of Availability Zones (between 2 and 4) to span subnet resources for high availability.
variable "az_count" {
  description = "Number of Availability Zones to use."
  type        = number
  default     = 2

  validation {
    condition     = var.az_count >= 2 && var.az_count <= 4
    error_message = "AZ count must be between 2 and 4."
  }
}

# Toggle to deploy NAT Gateways, allowing private services workloads outbound egress access to the internet.
variable "enable_nat_gateway" {
  description = "Whether private services subnets should route internet egress through NAT Gateway."
  type        = bool
  default     = false
}

# Toggle to share one single NAT Gateway across zones instead of provisioning one per zone (cost reduction).
variable "single_nat_gateway" {
  description = "Use one NAT Gateway instead of one per Availability Zone."
  type        = bool
  default     = true
}

# Toggle to provision a gateway VPC endpoint for Amazon S3 to keep traffic to S3 bucket private.
variable "enable_s3_endpoint" {
  description = "Create a gateway VPC endpoint for Amazon S3."
  type        = bool
  default     = true
}

variable "rds_database_name" {
  description = "Initial PostgreSQL database name."
  type        = string
  default     = "appdb"
}

variable "rds_instance_class" {
  description = "RDS PostgreSQL instance class."
  type        = string
  default     = "db.t4g.micro"
}

variable "rds_allocated_storage" {
  description = "Initial RDS PostgreSQL storage size in GiB."
  type        = number
  default     = 20
}

variable "rds_max_allocated_storage" {
  description = "Maximum RDS PostgreSQL storage size in GiB for autoscaling."
  type        = number
  default     = 100
}

variable "rds_multi_az" {
  description = "Whether RDS PostgreSQL is deployed as Multi-AZ."
  type        = bool
  default     = false
}

variable "rds_backup_retention_period" {
  description = "Number of days to retain RDS automated backups."
  type        = number
  default     = 1
}

variable "rds_deletion_protection" {
  description = "Whether RDS deletion protection is enabled."
  type        = bool
  default     = false
}

variable "rds_skip_final_snapshot" {
  description = "Whether to skip a final RDS snapshot when deleting the DB instance."
  type        = bool
  default     = true
}

variable "rds_performance_insights_enabled" {
  description = "Whether RDS Performance Insights is enabled."
  type        = bool
  default     = false
}
