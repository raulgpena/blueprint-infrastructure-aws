# name: Raul Pena (raul.pena@gmail.com)
# createAt: 2026-08-02T17:53:34-0300
# Description: Input variables for building standard tags and resource name prefixes.

variable "project" {
  description = "Project or application name."
  type        = string
}

variable "environment" {
  description = "Deployment environment."
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

variable "additional_tags" {
  description = "Additional tags merged with required tags."
  type        = map(string)
  default     = {}
}
