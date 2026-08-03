# name: Raul Pena (raul.pena@gmail.com)
# createAt: 2026-08-02T17:53:34-0300
# Description: AWS resources for SSE-S3 encrypted Terraform remote state storage.

# The primary S3 bucket to store the remote Terraform state file.
resource "aws_s3_bucket" "terraform_state" {
  bucket = var.state_bucket_name

  tags = local.tags
}

# Enable versioning on the S3 bucket to retain state file history and allow recovery from accidental overrides or deletions.
resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Configure default server-side encryption using Amazon S3 managed keys (SSE-S3 / AES256) for cost-efficiency.
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block all public access to the S3 bucket to secure state files containing sensitive infrastructure details.
resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enforce bucket owner ownership for objects uploaded to the bucket, disabling S3 Access Control Lists (ACLs).
resource "aws_s3_bucket_ownership_controls" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

# Define a lifecycle rule to expire noncurrent versions of state objects after a configured number of days to optimize storage cost.
resource "aws_s3_bucket_lifecycle_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    id     = "retain-noncurrent-state"
    status = "Enabled"

    noncurrent_version_expiration {
      noncurrent_days = var.noncurrent_version_retention_days
    }
  }
}
