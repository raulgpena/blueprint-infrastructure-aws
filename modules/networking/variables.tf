# name: Raul Pena (raul.pena@gmail.com)
# createAt: 2026-08-02T17:53:34-0300
# Description: Input variables for VPC, subnet, NAT Gateway, and VPC endpoint configuration.

# Prefix for naming resources to maintain standard naming conventions
variable "name_prefix" {
  description = "Prefix used for resource names."
  type        = string
}

# Base IPv4 CIDR block allocated for the VPC
variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
}

# Target Availability Zones for subnet placement
variable "availability_zones" {
  description = "Availability zones used for subnets."
  type        = list(string)

  # Enforce multi-AZ high availability deployment
  validation {
    condition     = length(var.availability_zones) >= 2
    error_message = "At least two Availability Zones are required."
  }
}

# Netmask bit addition for public subnet CIDR calculation
variable "public_subnet_newbits" {
  description = "Additional subnet bits for public subnets."
  type        = number
  default     = 8
}

# Netmask bit addition for private services subnet CIDR calculation
variable "services_subnet_newbits" {
  description = "Additional subnet bits for private services subnets."
  type        = number
  default     = 8
}

# Netmask bit addition for private data subnet CIDR calculation
variable "data_subnet_newbits" {
  description = "Additional subnet bits for private data subnets."
  type        = number
  default     = 8
}

# Enable or disable NAT Gateway deployment for outbound internet traffic
variable "enable_nat_gateway" {
  description = "Whether private services subnets should route internet egress through NAT Gateway."
  type        = bool
  default     = true
}

# Toggle single NAT Gateway to reduce non-production environment costs
variable "single_nat_gateway" {
  description = "Use one NAT Gateway instead of one per Availability Zone."
  type        = bool
  default     = false
}

# Toggle Gateway VPC Endpoint for direct S3 connectivity
variable "enable_s3_endpoint" {
  description = "Create a gateway VPC endpoint for Amazon S3."
  type        = bool
  default     = true
}
