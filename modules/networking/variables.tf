# name: Raul Pena (raul.pena@gmail.com)
# createAt: 2026-08-02T17:53:34-0300
# Description: Input variables for VPC, subnet, NAT Gateway, and VPC endpoint configuration.

variable "name_prefix" {
  description = "Prefix used for resource names."
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
}

variable "availability_zones" {
  description = "Availability zones used for subnets."
  type        = list(string)

  validation {
    condition     = length(var.availability_zones) >= 2
    error_message = "At least two Availability Zones are required."
  }
}

variable "public_subnet_newbits" {
  description = "Additional subnet bits for public subnets."
  type        = number
  default     = 8
}

variable "private_subnet_newbits" {
  description = "Additional subnet bits for private subnets."
  type        = number
  default     = 8
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

variable "tags" {
  description = "Tags applied to resources."
  type        = map(string)
}
