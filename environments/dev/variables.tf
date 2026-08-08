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

# RDS PostgreSQL configuration
variable "rds_database_name" {
  description = "Initial PostgreSQL database name."
  type        = string
  default     = "appdb"
}

# RDS PostgreSQL instance configuration
variable "rds_instance_class" {
  description = "RDS PostgreSQL instance class."
  type        = string
  default     = "db.t4g.micro"
}

# RDS PostgreSQL storage configuration
variable "rds_allocated_storage" {
  description = "Initial RDS PostgreSQL storage size in GiB."
  type        = number
  default     = 20
}

# RDS PostgreSQL autoscaling configuration
variable "rds_max_allocated_storage" {
  description = "Maximum RDS PostgreSQL storage size in GiB for autoscaling."
  type        = number
  default     = 100
}

# RDS PostgreSQL multi-AZ configuration
variable "rds_multi_az" {
  description = "Whether RDS PostgreSQL is deployed as Multi-AZ."
  type        = bool
  default     = false
}

# RDS PostgreSQL backup retention period
variable "rds_backup_retention_period" {
  description = "Number of days to retain RDS automated backups."
  type        = number
  default     = 1
}

# RDS PostgreSQL deletion protection configuration
variable "rds_deletion_protection" {
  description = "Whether RDS deletion protection is enabled."
  type        = bool
  default     = false
}

# RDS PostgreSQL skip final snapshot configuration
variable "rds_skip_final_snapshot" {
  description = "Whether to skip a final RDS snapshot when deleting the DB instance."
  type        = bool
  default     = true
}

# RDS Performance Insights configuration
variable "rds_performance_insights_enabled" {
  description = "Whether RDS Performance Insights is enabled."
  type        = bool
  default     = false
}

# RDS private SSM helper configuration
variable "enable_database_access_host" {
  description = "Whether to create a private SSM helper for developer database port forwarding."
  type        = bool
  default     = true
}

# RDS private SSM helper instance type configuration
variable "database_access_instance_type" {
  description = "EC2 instance type for the private SSM database access helper."
  type        = string
  default     = "t3.micro"
}

# RDS private SSM helper root volume size configuration
variable "database_access_root_volume_size" {
  description = "Root EBS volume size in GiB for the private SSM database access helper."
  type        = number
  default     = 8
}

# Optional private S3 artifact repository configuration
variable "create_maven_repository" {
  description = "Whether to create a private S3-backed Maven repository."
  type        = bool
  default     = false
}

# Optional private S3 artifact repository configuration
variable "create_helm_repository" {
  description = "Whether to create a private S3-backed Helm chart repository."
  type        = bool
  default     = false
}

# Optional private S3 artifact repository configuration
variable "maven_repository_bucket_name" {
  description = "Globally unique S3 bucket name for the Maven repository."
  type        = string
  default     = ""
}

# Optional private S3 artifact repository configuration
variable "helm_repository_bucket_name" {
  description = "Globally unique S3 bucket name for the Helm chart repository."
  type        = string
  default     = ""
}

# Optional private S3 artifact repository configuration
variable "maven_repository_prefix" {
  description = "S3 prefix used as the Maven repository root."
  type        = string
  default     = "maven"
}

# Optional private S3 artifact repository configuration
variable "helm_repository_prefix" {
  description = "S3 prefix used as the Helm chart repository root."
  type        = string
  default     = "charts"
}

# Optional private S3 artifact repository configuration
variable "artifact_repository_noncurrent_version_retention_days" {
  description = "Number of days to retain noncurrent artifact object versions."
  type        = number
  default     = 30
}

# Optional private S3 artifact repository configuration
variable "artifact_repository_force_destroy" {
  description = "Whether Terraform can delete non-empty artifact repository buckets."
  type        = bool
  default     = false
}

# Optional Route 53 public hosted zone configuration
variable "create_public_hosted_zone" {
  description = "Whether to create a Route 53 public hosted zone for an externally registered domain."
  type        = bool
  default     = false
}

# Optional Route 53 public hosted zone configuration
variable "public_hosted_zone_domain_name" {
  description = "Domain name for the Route 53 public hosted zone."
  type        = string
  default     = ""
}

# Optional Route 53 public hosted zone configuration
variable "public_hosted_zone_force_destroy" {
  description = "Whether Terraform can delete all records in the hosted zone when destroying it."
  type        = bool
  default     = false
}
