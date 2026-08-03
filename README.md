# name: Raul Pena (raul.pena@gmail.com)
# createAt: 2026-08-02T17:53:34-0300
# Description: Project documentation for the AWS Terraform infrastructure scaffold, workflows, layout, validation, and operational notes.

# Blueprint Infrastructure AWS

Terraform project scaffold for AWS infrastructure with reusable modules and separate environment roots.

## Prerequisites

- Terraform `>= 1.10.0, < 2.0.0`
- AWS CLI configured with credentials for the target account
- Explicit AWS profile and region verification before planning or applying

## Layout

```text
bootstrap/
  remote-state/       # Creates the S3 backend foundation
modules/
  networking/         # VPC, subnets, routing, optional NAT and S3 endpoint
  tags/               # Required common tags and name prefix
environments/
  dev/
    backend.local.hcl  # S3 backend configuration for dev state
    terraform.tfvars   # Dev input values
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
terraform init -backend-config=backend.local.hcl
terraform fmt -check
terraform validate
terraform plan -var-file=terraform.tfvars
```

Prefer saved plans for reviewed execution:

```sh
terraform plan -var-file=terraform.tfvars -out=tfplan
terraform apply tfplan
```

Do not commit plans, state files, credentials, or secrets. Treat `terraform.tfvars` and backend configuration files as environment-specific inputs and review them before use.

## Environments

The project includes `dev`, `staging`, and `prod` roots. Each root composes the same reusable modules with environment-specific values.

Production changes require explicit environment-specific approval, reviewed plans, and controlled execution.

## Dev VPC

With the current `environments/dev/terraform.tfvars`, the dev environment creates:

- VPC CIDR `10.10.0.0/16`
- Two Availability Zones in `us-east-1`
- Two public `/24` subnets:
  - `10.10.0.0/24`
  - `10.10.1.0/24`
- Two private `/24` subnets:
  - `10.10.2.0/24`
  - `10.10.3.0/24`
- One Internet Gateway
- One public route table with `0.0.0.0/0` routed to the Internet Gateway
- One private route table per private subnet
- One S3 Gateway VPC Endpoint attached to public and private route tables
- No NAT Gateway by default

Public subnets do not auto-assign public IPs on launch. Private subnets do not have general outbound internet access unless NAT Gateway or additional VPC endpoints are enabled.

## Cost Notes

Terraform state uses S3-managed server-side encryption (SSE-S3 / `AES256`) to avoid KMS monthly key and API request charges for backend state storage. Use SSE-KMS instead only when customer-managed key policies, KMS audit events, or stricter key lifecycle controls are required.

Terraform backend locking uses native S3 lock files with `use_lockfile = true`, which requires Terraform `>= 1.10.0`. DynamoDB-based S3 backend locking is deprecated by HashiCorp and is intentionally not used by this project.

The scaffold does not create customer-managed KMS keys by default. Prefer no-extra-cost service-managed encryption options, such as SSE-S3 for S3, unless a workload has compliance or access-control requirements that justify customer-managed KMS keys and their fixed monthly cost.

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
