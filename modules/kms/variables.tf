# name: Raul Pena (raul.pena@gmail.com)
# createAt: 2026-08-02T17:53:34-0300
# Description: Input variables for configuring reusable KMS keys and aliases.

variable "alias_name" {
  description = "KMS alias name without the alias/ prefix."
  type        = string
}

variable "description" {
  description = "KMS key description."
  type        = string
}

variable "deletion_window_in_days" {
  description = "KMS key deletion waiting period."
  type        = number
  default     = 30

  validation {
    condition     = var.deletion_window_in_days >= 7 && var.deletion_window_in_days <= 30
    error_message = "KMS deletion window must be between 7 and 30 days."
  }
}

variable "enable_key_rotation" {
  description = "Enable automatic KMS key rotation."
  type        = bool
  default     = true
}

variable "multi_region" {
  description = "Whether to create a multi-Region KMS key."
  type        = bool
  default     = false
}

variable "policy_json" {
  description = "Optional KMS key policy JSON. Defaults to the AWS provider policy behavior when null."
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags applied to KMS resources."
  type        = map(string)
}
