<!--
name: Raul Pena (raul.pena@gmail.com)
createAt: 2026-08-08T12:01:26-0300
Description: Long-term legacy session context for the AWS Terraform infrastructure blueprint.
-->

# Legacy Session Context

## Project Overview

This repository is an AWS infrastructure blueprint implemented with Terraform. It is intended to provide a secure, maintainable, multi-environment foundation for application teams that will deploy backend services, databases, caches, artifact repositories, and supporting network infrastructure on AWS.

The repository currently focuses on:

- Multi-environment Terraform roots for `dev`, `staging`, and `prod`.
- Reusable Terraform modules.
- Private networking by default.
- Cost-aware managed AWS services.
- Secure state management.
- Clear operational documentation.

The project is treated as infrastructure-as-code and should be evolved through reviewed Terraform plans, small scoped changes, and explicit approvals before mutating AWS resources.

## Goals And Objectives

- Build a reusable AWS Terraform project following AWS and Terraform best practices.
- Support multiple environments with separate root modules and separate state.
- Keep root modules small and explicit.
- Use reusable modules where lifecycle boundaries are clear.
- Prefer secure private infrastructure over public access.
- Optimize cost without weakening required security or recoverability.
- Avoid storing secrets in Git or plaintext variable files.
- Provide beginner-friendly operational documentation.
- Prepare the project for future workloads such as EKS, ECS, Fargate, and microservices.

## Architecture Decisions

- Use separate root modules for `dev`, `staging`, and `prod`.
- Use reusable modules for cohesive infrastructure concerns:
  - Networking
  - PostgreSQL RDS
  - ElastiCache Valkey
  - SSM port-forward helper
  - S3 artifact repositories
  - Route 53 public hosted zones
  - Remote state bootstrap
- Split environment composition files by resource type instead of using one large `main.tf`.
- Use provider `default_tags` for standard tags across resources.
- Keep only resource-specific tags, such as `Name`, inside modules.
- Use private data subnets for stateful backend services.
- Use private services subnets for application workloads.
- Keep public subnets available for future public entry points, but do not place databases or caches there.
- Use Systems Manager Session Manager for dev database access instead of a public bastion host.
- Use ElastiCache Valkey instead of Redis OSS for new Redis-compatible cache workloads.
- Use S3-native backend lock files instead of DynamoDB locking.
- Use SSE-S3 by default instead of customer-managed KMS keys to avoid fixed KMS key charges.

## Technology Stack And Versions

- Terraform CLI: `>= 1.10.0, < 2.0.0`
- Terraform AWS provider: `~> 5.80.0`
- AWS region used in current dev values: `us-east-1`
- Backend state:
  - S3 backend
  - SSE-S3 encryption
  - Native S3 lock file via `use_lockfile = true`
- Network:
  - AWS VPC
  - Public subnet tier
  - Private services subnet tier
  - Private data subnet tier
  - Optional NAT Gateway
  - S3 Gateway VPC Endpoint
  - SSM interface VPC endpoints for dev database access
- Data:
  - Amazon RDS PostgreSQL
  - Amazon ElastiCache Valkey
- Secrets:
  - AWS Secrets Manager for RDS-managed master password
- DNS:
  - Optional Route 53 public hosted zone for externally registered domains
- Artifact storage:
  - Optional private S3-backed Maven repository
  - Optional private S3-backed Helm chart repository
- Documentation:
  - Markdown
  - Mermaid
  - Draw.io / diagrams.net XML

## Constraints And Assumptions

- `AGENTS.md` must always be read before work starts.
- Default workflow is propose first and change only after explicit approval.
- Production changes require explicit production-specific approval.
- No `terraform apply` should be run without explicit approval and a reviewed plan.
- No secrets should be committed to Git.
- Terraform state is sensitive and must be stored remotely with encryption and locking.
- The user prefers cost-aware defaults.
- Customer-managed KMS keys are avoided unless there is a clear compliance or access-control requirement.
- Dev prioritizes low cost and developer convenience.
- Staging should be better than dev but does not need full production cost unless required.
- Production prioritizes reliability and deletion safety.
- Application workloads are expected to run in the services tier.
- Backend data services are expected to run in the data tier.
- S3 artifact repositories are only used for Maven and Helm. npm and NuGet should use AWS CodeArtifact later if needed.
- The external domain `momcorp.net` is managed at an external registrar such as GoDaddy, with DNS delegation to Route 53 when enabled.

## Development Standards

- Use `rg` or `rg --files` for repository search.
- Use `apply_patch` for manual file edits.
- Do not revert unrelated user changes.
- Keep changes focused and reversible.
- Preserve existing file header style.
- All new files must include:
  - `name: Raul Pena (raul.pena@gmail.com)`
  - `createAt: <timestamp>`
  - `Description: <description>`
- Prefer ASCII unless there is a clear reason to use non-ASCII.
- Add comments where they improve maintainability, not for obvious assignments.
- Validate formatting and whitespace after changes.
- Use Terraform modules with typed inputs, descriptions, validations, and outputs.
- Prefer stable maps and keys over index-based constructs for long-lived infrastructure.

## CI/CD Decisions

No CI/CD pipeline has been implemented yet.

Decisions and recommendations made:

- CI/CD should use short-lived AWS credentials through OIDC role assumption.
- Avoid long-lived AWS access keys in pipelines.
- Production should be deployed through reviewed plans and controlled workflows.
- Future pipelines should run:
  - `terraform fmt -check -recursive`
  - `terraform init` with the intended backend config
  - `terraform validate`
  - IaC security scanning such as `tfsec`, `checkov`, or `trivy config`
  - `terraform plan`
  - Human review before apply
- Saved plans are preferred for controlled apply.
- Production applies should not use `-auto-approve`.

## Infrastructure Decisions

### Remote State

- Remote state is bootstrapped with an S3 bucket.
- Encryption uses SSE-S3 (`AES256`) instead of SSE-KMS.
- DynamoDB state locking is intentionally not used.
- Terraform native S3 lock files are used with `use_lockfile = true`.
- Terraform CLI `>= 1.10.0` is required for native S3 lock file support.

### Networking

- Each environment creates a VPC.
- Subnets are split into:
  - Public subnets per Availability Zone
  - Private services subnets per Availability Zone
  - Private data subnets per Availability Zone
- Public subnets exist for future public entry points.
- Services subnets are intended for user workloads such as EKS, ECS, Fargate, or EC2.
- Data subnets are intended for backend services such as PostgreSQL, Valkey, Redis-compatible cache, Kafka, and other stateful services.
- Services and data tiers use separate route tables.
- S3 Gateway VPC Endpoint is associated with private route tables.
- NAT Gateway is optional for services.
- Data subnets do not receive NAT routes by design.

### PostgreSQL RDS

- RDS is private with `publicly_accessible = false`.
- RDS is deployed only in data subnets.
- A DB subnet group is created from `data_subnet_ids`.
- Security group ingress allows PostgreSQL `5432/tcp` only from the services security group.
- RDS storage encryption is enabled.
- RDS-managed master password is enabled so the password is stored in AWS Secrets Manager.
- Dev defaults are small and cost-aware.
- Prod defaults enable Multi-AZ and deletion protection.

### ElastiCache Valkey

- Valkey is used as the Redis-compatible cache engine.
- Valkey is deployed only in data subnets.
- A cache subnet group is created from `data_subnet_ids`.
- Security group ingress allows `6379/tcp` only from the services security group.
- Encryption at rest is enabled.
- In-transit encryption is enabled, so application clients must use TLS.
- No cache password is committed to Git.
- Dev uses a small single-node cache.
- Staging uses a small validation cache.
- Prod uses two nodes with automatic failover and Multi-AZ.

### Developer Database Access

- Dev uses a private SSM helper instance for PostgreSQL port forwarding.
- The helper has no public IP.
- No SSH bastion module exists yet.
- SSM interface endpoints are created for `ssm`, `ssmmessages`, and `ec2messages` because dev may run without NAT Gateway.
- Developers use the `postgresql_port_forward_command` output to connect locally.

### S3 Artifact Repositories

- Optional S3 repositories exist for Maven and Helm only.
- Buckets are private.
- Public access is blocked.
- Versioning is enabled.
- SSE-S3 encryption is used.
- Lifecycle retention applies to noncurrent object versions.
- npm and NuGet should use CodeArtifact later instead of S3.

### Route 53

- Dev can optionally create a Route 53 public hosted zone.
- The domain may be registered outside AWS, such as at GoDaddy.
- DNS works only after the external registrar delegates name servers to Route 53.
- Existing DNS records should be copied to Route 53 before changing registrar name servers.

## Security Decisions

- Prefer private subnets for workloads and data stores.
- Do not expose RDS or Valkey publicly.
- Restrict security groups by source security group and port.
- Store database password in Secrets Manager, not Git.
- Do not store secrets in Terraform variable files.
- Use SSE-S3 to avoid customer-managed KMS key cost where stricter KMS controls are not required.
- Use AWS-managed or service-managed encryption by default where appropriate.
- Use SSM Session Manager for dev database access instead of public SSH.
- Prefer IAM roles, federation, OIDC, and short-lived credentials.
- Future workloads should use workload identity such as EKS Pod Identity or IRSA.
- Treat Terraform state as sensitive.
- Do not expose plan files or state files in Git.

## Completed Work

- Created Terraform multi-environment structure for `dev`, `staging`, and `prod`.
- Created remote state bootstrap stack.
- Migrated backend locking decision to native S3 lock files.
- Removed DynamoDB backend locking requirement.
- Changed state encryption from SSE-KMS to SSE-S3.
- Removed customer-managed workload KMS module.
- Removed tag-only module.
- Centralized standard tags in provider `default_tags`.
- Created networking module with:
  - VPC
  - Public subnets
  - Private services subnets
  - Private data subnets
  - Route tables
  - Optional NAT Gateway
  - S3 Gateway Endpoint
  - Services security group
- Created PostgreSQL RDS module.
- Created dev SSM port-forward helper module.
- Changed SSM helper instance type to `t3.micro` to align with Free Tier-oriented EC2 defaults.
- Created optional S3 artifact repository module for Maven and Helm.
- Created optional Route 53 public hosted zone module.
- Added ElastiCache Valkey module.
- Wired Valkey into dev, staging, and prod.
- Added Valkey outputs.
- Added application connectivity documentation.
- Added Mermaid infrastructure diagram.
- Added Draw.io infrastructure diagram.
- Updated README and changelog across the work.
- Added this `docs/model` documentation structure.

## Pending Work

- Run successful `terraform validate` once the local AWS provider plugin handshake issue is resolved.
- Run security scanning with `tfsec`, `checkov`, or `trivy config`.
- Run `terraform plan` for each environment with exact backend and variable files.
- Review any plan actions before apply.
- Decide whether to commit `.terraform.lock.hcl` files created by environment initialization.
- Add CI/CD pipeline for Terraform checks and plan generation.
- Add ADRs for major architecture choices.
- Decide whether to add EKS, ECS, or another compute platform.
- Decide whether to add a bastion module later. Current recommendation is to keep SSM and add bastion only if explicitly required.
- Add monitoring, alarms, budgets, and cost anomaly detection.
- Add backup and restore testing procedures.
- Add production runbooks for RDS, Valkey, DNS, and Terraform state.
- Add Route 53 DNS records such as `api.momcorp.net` later if required.

## Open Questions

- Which AWS account strategy will be used long term: one account with separate states or AWS Organizations with separate accounts for prod, non-prod, shared services, security, and logging?
- Which compute platform will host services: EKS, ECS, Fargate, EC2, or a mix?
- Will production require customer-managed KMS keys for compliance?
- Will Valkey require authentication/user groups later, or are private subnets and security groups sufficient for the first phase?
- What are the RPO/RTO requirements for PostgreSQL and cache workloads?
- What observability platform will be used?
- What CI/CD platform will manage Terraform?
- Should Route 53 hosted zones be created only in dev or also in staging/prod?
- Will artifact publishing to S3 repositories need CI permissions and repository policies?

## Known Issues

- Local `terraform validate` is blocked by the AWS provider plugin failing to instantiate:
  - Error: `Failed to load plugin schemas`
  - Provider path seen: `.terraform/providers/registry.terraform.io/hashicorp/aws/5.80.0/darwin_arm64/terraform-provider-aws_v5.80.0_x5`
  - Reported architecture: `MachO architecture: CpuArm64`
  - Current architecture: `arm64`
- Earlier Terraform CLI `1.5.7` was incompatible with the project requirement `>= 1.10.0`.
- AWS credentials and SSO profile setup caused provider errors until AWS SSO values were configured.
- `terraform.tfvars` files for dev and staging may be local/ignored and are not necessarily tracked by Git.
- No AWS resources have been planned or applied by the assistant unless explicitly noted by the user outside this context.

## Important Commands

Format all Terraform:

```sh
terraform fmt -check -recursive
```

Initialize dev without backend:

```sh
terraform -chdir=environments/dev init -backend=false
```

Initialize staging without backend:

```sh
terraform -chdir=environments/staging init -backend=false
```

Initialize prod without backend:

```sh
terraform -chdir=environments/prod init -backend=false
```

Validate an environment:

```sh
terraform -chdir=environments/dev validate
```

Initialize dev with the configured backend:

```sh
terraform -chdir=environments/dev init -backend-config=backend.local.hcl
```

Plan dev:

```sh
terraform -chdir=environments/dev plan -var-file=terraform.tfvars
```

Get PostgreSQL port-forward command:

```sh
terraform -chdir=environments/dev output -raw postgresql_port_forward_command
```

Get Valkey endpoint:

```sh
terraform output -raw valkey_primary_endpoint_address
terraform output -raw valkey_port
```

Check whitespace:

```sh
git diff --check
```

Validate Draw.io XML:

```sh
xmllint --noout INFRASTRUCTURE_DIAGRAM.drawio
```

Check Route 53 name servers:

```sh
dig NS momcorp.net
```

## Repository Structure Discussed

```text
bootstrap/
  remote-state/
modules/
  elasticache-valkey/
  networking/
  rds-postgresql/
  route53-public-zone/
  s3-artifact-repository/
  ssm-port-forward-host/
environments/
  dev/
  staging/
  prod/
docs/
  model/
README.md
CHANGELOG.md
APPLICATION_CONNECTIVITY.md
INFRASTRUCTURE_DIAGRAM.md
INFRASTRUCTURE_DIAGRAM.drawio
AGENTS.md
```

## Naming Conventions

- Environment resource name prefix:
  - `${var.project}-${var.environment}`
- Example:
  - `blueprint-dev`
  - `blueprint-staging`
  - `blueprint-prod`
- Standard tags include:
  - `application`
  - `environment`
  - `owner`
  - `cost-center`
  - `managed-by`
  - `data-classification`
- Resource-specific `Name` tags are set inside modules.
- Environment roots are named by environment:
  - `environments/dev`
  - `environments/staging`
  - `environments/prod`
- Resource composition files are named by concern:
  - `networking.tf`
  - `postgresql.tf`
  - `cache.tf`
  - `database-access.tf`
  - `artifact-repositories.tf`
  - `dns.tf`

## Decisions Not Yet Reflected In The Repository

- CI/CD design is recommended but not implemented.
- Security scanning tools are recommended but not configured.
- Production observability, alarms, budgets, and runbooks are recommended but not implemented.
- Separate AWS accounts through AWS Organizations are recommended for mature environments but not implemented in Terraform.
- Route 53 DNS record `api.momcorp.net` was discussed and deferred.
- A bastion module was intentionally deferred.
- CodeArtifact was recommended for npm and NuGet if package repositories are needed later.
- Valkey authentication/user group configuration was not added yet; current access relies on private networking and security groups.

## Important Rationale

- Multi-environment roots reduce blast radius and make plans easier to review.
- Reusable modules avoid duplication while preserving clear lifecycle ownership.
- Separate services and data subnet tiers make the network model easier to reason about.
- Data subnets without NAT reduce accidental outbound internet access for backend services.
- S3 Gateway Endpoint reduces dependency on public internet paths for private S3 access.
- SSM port forwarding keeps dev database access private and avoids public SSH exposure.
- SSE-S3 avoids customer-managed KMS key fixed costs while preserving server-side encryption.
- Native S3 lock files remove the need for DynamoDB state locking in modern Terraform.
- Valkey is a better forward-looking Redis-compatible default on AWS because it is open-source governed and supported as a first-class ElastiCache engine.
- RDS-managed passwords reduce the risk of committing database credentials.

## Recommended Next Steps

- Resolve the local AWS provider plugin handshake issue.
- Run `terraform validate` successfully for all environments.
- Run Terraform plans for dev, staging, and prod.
- Review plan output for create/update/replace/destroy actions.
- Add CI/CD for formatting, validation, scanning, and plan generation.
- Add ADR files for the main architecture decisions.
- Add AWS budget and anomaly detection.
- Add CloudWatch alarms for RDS and Valkey.
- Add backup and restore test runbooks.
- Decide on compute platform and implement it as a separate module.
- Decide whether staging/prod need Route 53 hosted zones and DNS records.
- Revisit Valkey authentication if compliance requirements demand it.
