# name: Raul Pena (raul.pena@gmail.com)
# createAt: 2026-08-02T17:53:34-0300
# Description: S3 backend configuration for the dev environment Terraform state.

# Bucket where Terraform state will be stored in S3
bucket = "s3-blueprintmomcorp-states-bucket"

# Key path within the bucket for this environment's state file
key = "blueprint/dev/terraform.tfstate"

# AWS region for the backend
region = "us-east-1"

# Whether to enable server-side encryption for the state file
encrypt = true

# Whether to use a lock file to prevent concurrent modifications
use_lockfile = true
