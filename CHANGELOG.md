# name: Raul Pena (raul.pena@gmail.com)
# createAt: 2026-08-02T17:55:20-0300
# Description: Changelog for tracking notable changes to the AWS Terraform infrastructure project.

# Changelog

All notable changes to this Terraform infrastructure project are documented in this file.

## Unreleased

### Added

- Created the initial AWS Terraform infrastructure scaffold.
- Added multi-environment roots for `dev`, `staging`, and `prod`.
- Added reusable modules for common tags, KMS keys, and VPC networking.
- Added a remote-state bootstrap stack for encrypted S3 state storage and DynamoDB locking.
- Added example backend and variable files for each environment.
- Added project documentation, Terraform ignore rules, and Terraform CLI version metadata.
- Added standard file headers with owner, creation timestamp, and file descriptions.

### Validation

- Verified Terraform formatting with `terraform fmt -check -recursive`.
- Verified the provider-free tags module with `terraform -chdir=modules/tags validate`.
- Initialized the `dev` environment with `terraform -chdir=environments/dev init -backend=false`.

### Known Limitations

- Full AWS-provider validation for `environments/dev` is currently blocked by the local Terraform runtime failing to instantiate the downloaded AWS provider plugin.
- No AWS resources have been planned, created, modified, or destroyed.
