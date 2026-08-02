# name: Raul Pena (raul.pena@gmail.com)
# createAt: 2026-08-02T17:53:34-0300
# Description: Input variables for configuring the dev environment root module.

variable "aws_region" {
  description = "AWS region."
  type        = string
}

variable "project" {
  description = "Project or application name."
  type        = string
}

variable "environment" {
  description = "Environment name."
  type        = string
  default     = "dev"

  validation {
    condition     = var.environment == "dev"
    error_message = "This root module is dedicated to the dev environment."
  }
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

variable "additional_tags" {
  description = "Additional tags merged with required tags."
  type        = map(string)
  default     = {}
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
}

variable "az_count" {
  description = "Number of Availability Zones to use."
  type        = number
  default     = 2

  validation {
    condition     = var.az_count >= 2 && var.az_count <= 4
    error_message = "AZ count must be between 2 and 4."
  }
}

variable "enable_nat_gateway" {
  description = "Whether private subnets should route internet egress through NAT Gateway."
  type        = bool
  default     = false
}

variable "single_nat_gateway" {
  description = "Use one NAT Gateway instead of one per Availability Zone."
  type        = bool
  default     = true
}

variable "enable_s3_endpoint" {
  description = "Create a gateway VPC endpoint for Amazon S3."
  type        = bool
  default     = true
}
