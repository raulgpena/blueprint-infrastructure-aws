# name: Raul Pena (raul.pena@gmail.com)
# createAt: 2026-08-04T21:50:02-0300
# Description: Input variables for creating a private SSM port-forwarding EC2 helper.

variable "name_prefix" {
  description = "Prefix used for SSM helper resource names."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the SSM helper and endpoints are created."
  type        = string
}

variable "subnet_id" {
  description = "Private subnet ID where the SSM helper instance is created."
  type        = string
}

variable "endpoint_subnet_ids" {
  description = "Private subnet IDs where SSM interface endpoints are created."
  type        = list(string)
}

variable "instance_security_group_ids" {
  description = "Security groups attached to the SSM helper instance."
  type        = list(string)
}

variable "endpoint_source_security_group_ids" {
  description = "Security groups allowed to connect to the SSM interface endpoints over HTTPS."
  type        = list(string)
}

variable "instance_type" {
  description = "EC2 instance type for the SSM helper."
  type        = string
  default     = "t4g.nano"
}

variable "root_volume_size" {
  description = "Root EBS volume size in GiB."
  type        = number
  default     = 8
}
