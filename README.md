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
  networking/         # VPC, public/services/data subnets, routing, optional NAT and S3 endpoint
  rds-postgresql/     # Private PostgreSQL RDS instance, subnet group, and security group
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
- Keep simple computed values, such as tags and name prefixes, in environment locals.
- Apply standard AWS tags through provider `default_tags`; modules should only set resource-specific tags such as `Name`.
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
- Two private services `/24` subnets:
  - `10.10.2.0/24`
  - `10.10.3.0/24`
- Two private data `/24` subnets:
  - `10.10.4.0/24`
  - `10.10.5.0/24`
- One Internet Gateway
- One public route table with `0.0.0.0/0` routed to the Internet Gateway
- One private services route table per services subnet
- One private data route table per data subnet
- One S3 Gateway VPC Endpoint attached to services and data route tables
- No NAT Gateway by default

Public subnets do not auto-assign public IPs on launch. Services subnets can optionally use NAT Gateway for outbound internet access. Data subnets do not receive a NAT route and should stay reachable only from controlled private paths.

## PostgreSQL RDS

The project includes a reusable PostgreSQL RDS module. Each environment places PostgreSQL only in the private `data` subnet tier and allows port `5432` only from the private services security group.

Environment defaults:

| Environment | Instance class | Storage | Multi-AZ | Backups | Deletion protection |
| --- | --- | --- | --- | --- | --- |
| `dev` | `db.t4g.micro` | 20 GiB gp3 | No | 1 day | No |
| `staging` | `db.t4g.small` | 30 GiB gp3 | No | 3 days | No |
| `prod` | `db.t4g.medium` | 50 GiB gp3 | Yes | 7 days | Yes |

RDS is configured with `publicly_accessible = false`, storage encryption enabled, and RDS-managed master password support. This avoids storing the database password in Git or plain Terraform variable files. The managed password is stored in AWS Secrets Manager, which can have a small monthly cost.

## Cost Notes

Terraform state uses S3-managed server-side encryption (SSE-S3 / `AES256`) to avoid KMS monthly key and API request charges for backend state storage. Use SSE-KMS instead only when customer-managed key policies, KMS audit events, or stricter key lifecycle controls are required.

Terraform backend locking uses native S3 lock files with `use_lockfile = true`, which requires Terraform `>= 1.10.0`. DynamoDB-based S3 backend locking is deprecated by HashiCorp and is intentionally not used by this project.

The scaffold does not create customer-managed KMS keys by default. Prefer no-extra-cost service-managed encryption options, such as SSE-S3 for S3, unless a workload has compliance or access-control requirements that justify customer-managed KMS keys and their fixed monthly cost.

RDS cost is driven mainly by the DB instance class, storage size, backup retention, Multi-AZ, and optional observability features. Dev uses a small Single-AZ instance for cost control. Prod enables Multi-AZ and deletion protection for reliability.

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
