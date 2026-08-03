# name: Raul Pena (raul.pena@gmail.com)
# createAt: 2026-08-02T17:53:34-0300
# Description: Input variables for configuring the Terraform remote state bootstrap stack.

# The target AWS region where S3 backend resources will be deployed.
# Must be compatible with the region used by the rest of the application deployment stacks.
variable "aws_region" {
  description = "AWS region for the Terraform state backend resources."
  type        = string
}

# The name of the project or application.
# Used dynamically for generating naming prefixes and tags to group resources.
variable "project" {
  description = "Project or application name used for naming and tags."
  type        = string
}

# Deployment environment name (e.g., dev, staging, prod).
# Used to isolate backends and differentiate infrastructure environments.
variable "environment" {
  description = "Environment name for this backend boundary."
  type        = string
}

# The owner/team accountable for maintaining and operating these resources.
# Included in the default tagging policy.
variable "owner" {
  description = "Team or person accountable for these resources."
  type        = string
}

# Cost center identifier for resource tagging.
# Essential for cost allocation, billing analytics, and department chargebacks.
variable "cost_center" {
  description = "Cost allocation identifier."
  type        = string
}

# Data classification rating for security and compliance auditing (e.g., public, internal, confidential).
# Helps identify the sensitivity of the stored state. Defaults to "internal".
variable "data_classification" {
  description = "Data classification tag value."
  type        = string
  default     = "internal"
}

# The globally unique name of the S3 bucket that stores Terraform state.
# Must comply with S3 bucket naming requirements.
variable "state_bucket_name" {
  description = "Globally unique S3 bucket name for Terraform state."
  type        = string
}

# The number of days noncurrent state object versions are retained in S3 before expiration.
# Allows historical rollback / disaster recovery in case of state corruption. Must be at least 30 days.
variable "noncurrent_version_retention_days" {
  description = "Number of days to retain noncurrent state object versions."
  type        = number
  default     = 90

  validation {
    condition     = var.noncurrent_version_retention_days >= 30
    error_message = "Retain noncurrent state versions for at least 30 days."
  }
}
