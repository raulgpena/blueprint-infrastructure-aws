<!--
name: Raul Pena (raul.pena@gmail.com)
createAt: 2026-08-08T12:25:08-0300
Description: Changelog for GitHub Actions workflows that operate the Terraform infrastructure project.
-->

# Workflow Changelog

All notable changes to GitHub Actions workflows are documented in this file.

## Unreleased

### Added

- Added `terraform-deploy.yml` for Terraform validation, planning, and controlled apply.
- Added automatic workflow execution on pushes to `release/deploy`.
- Covered pull request merges into `release/deploy` through the GitHub push event created by merge commits.
- Added manual workflow execution with environment and action inputs.
- Added support for `dev`, `staging`, and `prod` GitHub environments.
- Added GitHub OIDC authentication for AWS role assumption without long-lived access keys.
- Added Terraform formatting, initialization, validation, planning, plan artifact upload, and optional apply steps.
- Added manual-only Terraform destroy support using a saved destroy plan.
- Added a workflow re-run guard using `github.run_attempt == 1`.
- Added workflow documentation in `.github/workflows/README.md`.

### Security

- Workflow permissions are limited to `contents: read` and `id-token: write`.
- AWS credentials are obtained through OIDC role assumption.
- Terraform apply is manual-only and should be protected with GitHub environment approvals.
- Terraform destroy is manual-only and should be protected with GitHub environment approvals.

### Known Limitations

- GitHub still displays the "Re-run jobs" button; the workflow prevents Terraform execution on re-run attempts through a job-level guard.
- The workflow requires real `backend.local.hcl` and `terraform.tfvars` files for each target environment.
- AWS IAM roles and GitHub environment variables must be configured before the workflow can run successfully.
