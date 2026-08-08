# name: Raul Pena (raul.pena@gmail.com)
# createAt: 2026-08-08T09:55:10-0300
# Description: Output values exported by the reusable S3 artifact repository module.

output "bucket_names" {
  description = "Artifact repository bucket names by repository type."
  value       = { for name, bucket in aws_s3_bucket.this : name => bucket.id }
}

output "bucket_arns" {
  description = "Artifact repository bucket ARNs by repository type."
  value       = { for name, bucket in aws_s3_bucket.this : name => bucket.arn }
}

output "repository_uris" {
  description = "S3 repository URIs by repository type."
  value = {
    for name, repository in local.enabled_repositories :
    name => "s3://${aws_s3_bucket.this[name].id}/${local.repository_prefixes[name]}/"
  }
}
