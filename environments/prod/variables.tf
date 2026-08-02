# name: Raul Pena (raul.pena@gmail.com)
# createAt: 2026-08-02T17:53:34-0300
# Description: Input variables for configuring the prod environment root module.

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
  default     = "prod"

  validation {
    condition     = var.environment == "prod"
    error_message = "This root module is dedicated to the prod environment."
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
  default     = "confidential"
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
  default     = 3

  validation {
    condition     = var.az_count >= 3 && var.az_count <= 4
    error_message = "Production AZ count must be between 3 and 4."
  }
}

variable "enable_nat_gateway" {
  description = "Whether private subnets should route internet egress through NAT Gateway."
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Use one NAT Gateway instead of one per Availability Zone."
  type        = bool
  default     = false
}

variable "enable_s3_endpoint" {
  description = "Create a gateway VPC endpoint for Amazon S3."
  type        = bool
  default     = true
}
