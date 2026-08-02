# name: Raul Pena (raul.pena@gmail.com)
# createAt: 2026-08-02T17:53:34-0300
# Description: Project documentation for the AWS Terraform infrastructure scaffold, workflows, layout, validation, and operational notes.

# Blueprint Infrastructure AWS

Terraform project scaffold for AWS infrastructure with reusable modules and separate environment roots.

## Layout

```text
bootstrap/
  remote-state/       # Creates the S3/DynamoDB backend foundation
modules/
  kms/                # Customer-managed KMS keys
  networking/         # VPC, subnets, routing, optional NAT and S3 endpoint
  tags/               # Required common tags and name prefix
environments/
  dev/
  staging/
  prod/
```

## Design Principles

- Keep environment roots small and explicit.
- Put shared infrastructure behavior in reusable modules.
- Use separate Terraform state per environment.
- Encrypt state and AWS resources by default where supported.
- Prefer private subnets for workloads.
- Tag all supported resources consistently.
- Review plans before any apply.

## Initial Workflow

Bootstrap remote state once per account or environment boundary:

```sh
cd bootstrap/remote-state
terraform init
terraform fmt -check
terraform validate
terraform plan -out=tfplan
```

After reviewing the plan, apply only with explicit approval:

```sh
terraform apply tfplan
```

Configure an environment backend from its example:

```sh
cd environments/dev
cp backend.hcl.example backend.hcl
terraform init -backend-config=backend.hcl
terraform fmt -check
terraform validate
terraform plan -var-file=terraform.tfvars
```

Do not commit `backend.hcl`, `terraform.tfvars`, plans, state files, credentials, or secrets.

## Environments

The project includes `dev`, `staging`, and `prod` roots. Each root composes the same reusable modules with environment-specific values.

Production changes require explicit environment-specific approval, reviewed plans, and controlled execution.

## Cost Notes

NAT Gateway is enabled by environment input. A single NAT Gateway is cheaper but has an Availability Zone dependency. One NAT Gateway per AZ improves availability and avoids cross-AZ routing for private egress, but costs more. Development can disable NAT or use a single NAT Gateway depending on workload needs.

## Validation

Typical checks before proposing an apply:

```sh
terraform fmt -check -recursive
terraform init
terraform validate
terraform plan
```

Add IaC scanning such as `tfsec`, `checkov`, or `trivy config` in CI before production use.
