# name: Raul Pena (raul.pena@gmail.com)
# createAt: 2026-08-08T09:55:10-0300
# Description: Dev environment optional S3-backed Maven and Helm artifact repositories.

# S3 artifact repository module
module "artifact_repositories" {
  source = "../../modules/s3-artifact-repository"

  repositories = {
    maven = {
      enabled     = var.create_maven_repository
      bucket_name = var.maven_repository_bucket_name
      prefix      = var.maven_repository_prefix
    }
    helm = {
      enabled     = var.create_helm_repository
      bucket_name = var.helm_repository_bucket_name
      prefix      = var.helm_repository_prefix
    }
  }

  noncurrent_version_retention_days = var.artifact_repository_noncurrent_version_retention_days
  force_destroy                     = var.artifact_repository_force_destroy
}
