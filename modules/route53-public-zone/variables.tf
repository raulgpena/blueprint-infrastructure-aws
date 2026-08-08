# name: Raul Pena (raul.pena@gmail.com)
# createAt: 2026-08-08T10:25:30-0300
# Description: Input variables for optional Route 53 public hosted zones.

variable "create" {
  description = "Whether to create the public hosted zone."
  type        = bool
  default     = false
}

variable "domain_name" {
  description = "Domain name for the Route 53 public hosted zone."
  type        = string
  default     = ""
}

variable "comment" {
  description = "Optional hosted zone comment."
  type        = string
  default     = "Managed by Terraform"
}

variable "force_destroy" {
  description = "Whether to destroy all records in the hosted zone when deleting it."
  type        = bool
  default     = false
}
