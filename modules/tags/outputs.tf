# name: Raul Pena (raul.pena@gmail.com)
# createAt: 2026-08-02T17:53:34-0300
# Description: Standardized tag and name prefix outputs for reuse by other modules.

output "name_prefix" {
  description = "Consistent prefix for resource names."
  value       = local.name_prefix
}

output "tags" {
  description = "Merged required and additional tags."
  value       = merge(local.required_tags, var.additional_tags)
}
