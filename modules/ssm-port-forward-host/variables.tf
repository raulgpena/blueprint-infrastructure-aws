# name: Raul Pena (raul.pena@gmail.com)
# createAt: 2026-08-04T21:50:02-0300
# Description: Input variables for creating a private SSM port-forwarding EC2 helper.

# Prefix for naming SSM helper and endpoint resources
variable "name_prefix" {
  description = "Prefix used for SSM helper resource names."
  type        = string
}

# Target VPC ID for the host and interface endpoints
variable "vpc_id" {
  description = "VPC ID where the SSM helper and endpoints are created."
  type        = string
}

# Subnet ID where the EC2 bastion instance is launched
variable "subnet_id" {
  description = "Private subnet ID where the SSM helper instance is created."
  type        = string
}

# Subnet IDs where SSM interface endpoints are provisioned
variable "endpoint_subnet_ids" {
  description = "Private subnet IDs where SSM interface endpoints are created."
  type        = list(string)
}

# Security group IDs associated with the EC2 bastion instance
variable "instance_security_group_ids" {
  description = "Security groups attached to the SSM helper instance."
  type        = list(string)
}

# Security group IDs authorized to reach the SSM VPC interface endpoints
variable "endpoint_source_security_group_ids" {
  description = "Security groups allowed to connect to the SSM interface endpoints over HTTPS."
  type        = list(string)
}

# EC2 instance sizing for the SSM helper host
variable "instance_type" {
  description = "EC2 instance type for the SSM helper."
  type        = string
  default     = "t3.micro"
}

# Size in GiB of the encrypted root EBS volume
variable "root_volume_size" {
  description = "Root EBS volume size in GiB."
  type        = number
  default     = 8
}
