# name: Raul Pena (raul.pena@gmail.com)
# createAt: 2026-08-08T09:55:10-0300
# Description: Private S3 buckets for static Maven and Helm artifact repositories.

locals {
  enabled_repositories = {
    for name, repository in var.repositories : name => repository
    if repository.enabled
  }

  repository_prefixes = {
    for name, repository in local.enabled_repositories :
    name => trimsuffix(repository.prefix, "/") == "" ? name : trimsuffix(repository.prefix, "/")
  }
}

resource "aws_s3_bucket" "this" {
  for_each = local.enabled_repositories

  bucket        = each.value.bucket_name
  force_destroy = var.force_destroy

  tags = {
    Name       = each.value.bucket_name
    repository = each.key
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  for_each = aws_s3_bucket.this

  bucket = each.value.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "this" {
  for_each = aws_s3_bucket.this

  bucket = each.value.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_versioning" "this" {
  for_each = aws_s3_bucket.this

  bucket = each.value.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  for_each = aws_s3_bucket.this

  bucket = each.value.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  for_each = aws_s3_bucket.this

  bucket = each.value.id

  rule {
    id     = "expire-noncurrent-artifacts"
    status = "Enabled"

    noncurrent_version_expiration {
      noncurrent_days = var.noncurrent_version_retention_days
    }
  }
}

resource "aws_s3_object" "repository_prefix" {
  for_each = local.enabled_repositories

  bucket       = aws_s3_bucket.this[each.key].id
  key          = "${local.repository_prefixes[each.key]}/"
  content      = ""
  content_type = "application/x-directory"

  depends_on = [
    aws_s3_bucket_public_access_block.this,
    aws_s3_bucket_ownership_controls.this,
    aws_s3_bucket_server_side_encryption_configuration.this,
  ]
}
