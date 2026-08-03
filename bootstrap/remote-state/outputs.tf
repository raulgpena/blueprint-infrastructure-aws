# name: Raul Pena (raul.pena@gmail.com)
# createAt: 2026-08-02T17:53:34-0300
# Description: Output values exported by the Terraform remote state bootstrap stack.

# The globally unique name of the S3 bucket where Terraform state files are stored.
output "state_bucket_name" {
  description = "S3 bucket name for Terraform state."
  value       = aws_s3_bucket.terraform_state.id
}
