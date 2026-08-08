<!--
name: Raul Pena (raul.pena@gmail.com)
createAt: 2026-08-08T12:25:08-0300
Description: Documentation for GitHub Actions workflows that operate the Terraform infrastructure project.
-->

# GitHub Workflows

This directory contains GitHub Actions workflows for operating the Terraform infrastructure project.

## Terraform Deploy Workflow

The main workflow is:

```text
terraform-deploy.yml
```

It validates, plans, and optionally applies Terraform from the `release/deploy` branch.

## Triggers

The workflow runs automatically when code is pushed to:

```text
release/deploy
```

This covers two cases:

- A direct push to `release/deploy`.
- A pull request merged into `release/deploy`, because GitHub creates a push event for the merge commit.

The workflow can also be started manually from the GitHub Actions UI with `workflow_dispatch`.

## Manual Inputs

Manual runs require:

- `environment`: `dev`, `staging`, or `prod`
- `action`: `plan`, `apply`, or `destroy`

Automatic push runs default to:

- `environment`: `dev`
- `action`: `plan`

Automatic runs do not apply Terraform.

Automatic runs also do not destroy Terraform-managed resources. Destroy is available only through manual workflow execution.

## Re-Run Guard

GitHub does not provide a workflow setting that removes the "Re-run jobs" button.

The workflow uses this guard:

```yaml
if: github.run_attempt == 1
```

This means Terraform steps execute only on the first workflow attempt. If someone re-runs the workflow, the job is skipped before Terraform can run again.

## AWS Authentication

The workflow uses GitHub OIDC to assume AWS IAM roles. It does not use long-lived AWS access keys.

Required GitHub variables:

- `AWS_REGION`
- `AWS_ROLE_ARN_DEV`
- `AWS_ROLE_ARN_STAGING`
- `AWS_ROLE_ARN_PROD`

The AWS IAM roles must trust GitHub OIDC for this repository and the intended branch.

## GitHub Environments

Create these GitHub environments:

- `dev`
- `staging`
- `prod`

Use environment protection rules for sensitive environments. Production should require human approval before an apply can run.

## Required Terraform Files

Each environment must have:

```text
environments/<environment>/backend.local.hcl
environments/<environment>/terraform.tfvars
```

The workflow intentionally fails when either file is missing. This prevents it from planning or applying with the wrong backend or incomplete variables.

## Workflow Steps

The workflow runs:

- Repository checkout
- Target environment resolution
- AWS OIDC authentication
- Terraform setup
- `terraform fmt -check -recursive`
- `terraform init`
- `terraform validate`
- `terraform plan` or `terraform plan -destroy`
- Plan artifact upload
- Optional `terraform apply` from the saved plan
- Optional destroy by applying the saved destroy plan

## Safety Notes

- Treat uploaded Terraform plan artifacts as sensitive infrastructure metadata.
- Review every plan before applying.
- Review every destroy plan before continuing with destructive execution.
- Use GitHub environment approvals for production.
- Keep AWS permissions least-privilege in the assumed IAM roles.
- Do not store AWS credentials or Terraform secrets in GitHub workflow files.
