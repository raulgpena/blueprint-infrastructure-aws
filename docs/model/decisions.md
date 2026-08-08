<!--
name: Raul Pena (raul.pena@gmail.com)
createAt: 2026-08-08T12:01:26-0300
Description: High-level architecture and infrastructure decisions for the AWS Terraform blueprint.
-->

# Decisions

## Accepted Decisions

- Use Terraform with reusable modules and separate environment roots.
- Use S3 remote state with SSE-S3 encryption.
- Use Terraform native S3 lock files instead of DynamoDB locking.
- Avoid customer-managed KMS keys by default to reduce fixed cost.
- Use provider `default_tags` for standard tags.
- Use private data subnets for RDS and Valkey.
- Use private services subnets for application workloads.
- Use SSM port forwarding for dev database access instead of a public bastion.
- Use ElastiCache Valkey for Redis-compatible cache workloads.
- Use S3 for Maven and Helm artifact repositories only.
- Defer npm and NuGet package repositories to AWS CodeArtifact.
- Use GitHub Actions from the `release/deploy` branch for Terraform automation.
- Use GitHub OIDC to assume AWS IAM roles instead of storing long-lived AWS access keys.
- Automatically run Terraform plan on `release/deploy` pushes and merged pull requests.
- Allow manual Terraform plan/apply/destroy through `workflow_dispatch`.
- Require destroy to use a saved destroy plan generated in the same workflow run.
- Block Terraform execution on workflow re-run attempts with `github.run_attempt == 1`.

## Decisions To Record As ADRs

- Remote state locking with native S3 lock files.
- SSE-S3 instead of customer-managed KMS keys by default.
- Services/data subnet tier separation.
- SSM-based dev database access.
- Valkey as the Redis-compatible cache engine.
- S3 for Maven and Helm artifacts.
- GitHub Actions Terraform deployment workflow and AWS OIDC role model.
