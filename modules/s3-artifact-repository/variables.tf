# name: Raul Pena (raul.pena@gmail.com)
# createAt: 2026-08-08T09:55:10-0300
# Description: Input variables for private S3-backed Maven and Helm artifact repositories.

# Map of artifact repository configurations
variable "repositories" {
  description = "Artifact repositories to create, keyed by repository type."
  # Object schema defining enablement, bucket name, and path prefix
  type = map(object({
    enabled     = bool
    bucket_name = string
    prefix      = string
  }))

  # Restrict repository keys to supported types: maven and helm
  validation {
    condition = alltrue([
      for name in keys(var.repositories) : contains(["maven", "helm"], name)
    ])
    error_message = "Only maven and helm repositories are supported by this S3 module."
  }
}

# Retention period for previous artifact versions
variable "noncurrent_version_retention_days" {
  description = "Number of days to retain noncurrent artifact object versions."
  type        = number
  default     = 30

  # Ensure retention is positive and at least 1 day
  validation {
    condition     = var.noncurrent_version_retention_days >= 1
    error_message = "Noncurrent version retention must be at least 1 day."
  }
}

# Safety flag to prevent accidental bucket deletion when objects exist
variable "force_destroy" {
  description = "Whether Terraform can delete non-empty artifact buckets. Keep false for safer repository deletion."
  type        = bool
  default     = false
}
