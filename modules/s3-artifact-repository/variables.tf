# name: Raul Pena (raul.pena@gmail.com)
# createAt: 2026-08-08T09:55:10-0300
# Description: Input variables for private S3-backed Maven and Helm artifact repositories.

variable "repositories" {
  description = "Artifact repositories to create, keyed by repository type."
  type = map(object({
    enabled     = bool
    bucket_name = string
    prefix      = string
  }))

  validation {
    condition = alltrue([
      for name in keys(var.repositories) : contains(["maven", "helm"], name)
    ])
    error_message = "Only maven and helm repositories are supported by this S3 module."
  }
}

variable "noncurrent_version_retention_days" {
  description = "Number of days to retain noncurrent artifact object versions."
  type        = number
  default     = 30

  validation {
    condition     = var.noncurrent_version_retention_days >= 1
    error_message = "Noncurrent version retention must be at least 1 day."
  }
}

variable "force_destroy" {
  description = "Whether Terraform can delete non-empty artifact buckets. Keep false for safer repository deletion."
  type        = bool
  default     = false
}
