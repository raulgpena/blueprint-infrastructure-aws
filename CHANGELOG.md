# Changelog

All notable changes to this Terraform infrastructure project are documented in this file.

## Unreleased

### Added

- Created the initial AWS Terraform infrastructure scaffold.
- Added multi-environment roots for `dev`, `staging`, and `prod`.
- Added a reusable module for VPC networking.
- Added a reusable private PostgreSQL RDS module with environment-specific dev, staging, and prod defaults.
- Added a dev-only private SSM database access helper for PostgreSQL port forwarding.
- Added optional dev S3 artifact repositories for Maven artifacts and Helm charts.
- Added optional dev Route 53 public hosted zone support for externally registered domains.
- Added a reusable private ElastiCache Valkey module and environment wiring for `dev`, `staging`, and `prod`, including private data subnet placement, services-tier-only security group ingress, encryption at rest, in-transit encryption, snapshots, and endpoint outputs.
- Added a remote-state bootstrap stack for encrypted S3 state storage.
- Added example backend and variable files for each environment.
- Added project documentation, Terraform ignore rules, and Terraform CLI version metadata.
- Added standard file headers with owner, creation timestamp, and file descriptions.

### Changed

- Changed Terraform remote state bucket encryption from SSE-KMS to SSE-S3 (`AES256`) to avoid KMS key and request charges.
- Split environment root composition from monolithic `main.tf` files into resource-specific files.
- Changed Terraform backend locking from deprecated DynamoDB-based locking to native S3 lock files with `use_lockfile = true`.
- Updated Terraform version requirements to `>= 1.10.0, < 2.0.0` for native S3 backend lock file support.
- Simplified networking module tagging by relying on provider `default_tags` for standard tags and keeping only resource-specific tags in the module.
- Split the networking module private tier into separate `services` and `data` subnet tiers with independent route tables.
- Added a private services security group and restricted PostgreSQL ingress to that security group.
- Added private SSM interface endpoints for dev database access without public SSH or NAT Gateway.
- Changed the dev SSM database access helper to `t3.micro` with standard CPU credits for Free Tier-oriented EC2 defaults.
- Documented Valkey usage, Redis-compatible connection outputs, TLS expectations, environment defaults, and cost notes in the README.

### Removed

- Removed the reusable KMS module and per-environment workload KMS keys to avoid fixed monthly customer-managed KMS key charges.
- Removed the tag-only module and replaced it with environment-local tag and name-prefix values.

### Validation

- Verified Terraform formatting with `terraform fmt -check -recursive`.
- Initialized the `dev`, `staging`, and `prod` environments with `terraform init -backend=false`.

### Known Limitations

- Full AWS-provider validation for `environments/dev`, `environments/staging`, and `environments/prod` is currently blocked by the local Terraform runtime failing to instantiate the downloaded AWS provider plugin.
- No AWS resources have been planned, created, modified, or destroyed.
