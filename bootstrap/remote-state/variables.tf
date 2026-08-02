# name: Raul Pena (raul.pena@gmail.com)
# createAt: 2026-08-02T17:53:34-0300
# Description: Input variables for configuring the Terraform remote state bootstrap stack.

variable "aws_region" {
  description = "AWS region for the Terraform state backend resources."
  type        = string
}

variable "project" {
  description = "Project or application name used for naming and tags."
  type        = string
}

variable "environment" {
  description = "Environment name for this backend boundary."
  type        = string
}

variable "owner" {
  description = "Team or person accountable for these resources."
  type        = string
}

variable "cost_center" {
  description = "Cost allocation identifier."
  type        = string
}

variable "data_classification" {
  description = "Data classification tag value."
  type        = string
  default     = "internal"
}

variable "state_bucket_name" {
  description = "Globally unique S3 bucket name for Terraform state."
  type        = string
}

variable "lock_table_name" {
  description = "DynamoDB table name for Terraform state locking."
  type        = string
}

variable "kms_deletion_window_in_days" {
  description = "KMS key deletion waiting period."
  type        = number
  default     = 30

  validation {
    condition     = var.kms_deletion_window_in_days >= 7 && var.kms_deletion_window_in_days <= 30
    error_message = "KMS deletion window must be between 7 and 30 days."
  }
}

variable "noncurrent_version_retention_days" {
  description = "Number of days to retain noncurrent state object versions."
  type        = number
  default     = 90

  validation {
    condition     = var.noncurrent_version_retention_days >= 30
    error_message = "Retain noncurrent state versions for at least 30 days."
  }
}
