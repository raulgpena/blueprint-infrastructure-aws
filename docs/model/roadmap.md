<!--
name: Raul Pena (raul.pena@gmail.com)
createAt: 2026-08-08T12:01:26-0300
Description: Planned roadmap for the AWS Terraform infrastructure blueprint.
-->

# Roadmap

## Near Term

- Resolve the local AWS provider plugin validation issue.
- Run successful Terraform validation for all environments.
- Run reviewed Terraform plans for dev, staging, and prod.
- Add CI checks for formatting, validation, and security scanning.
- Add ADRs for the major architecture decisions.

## Medium Term

- Add compute platform support, likely EKS, ECS, or Fargate.
- Add CloudWatch alarms for RDS, Valkey, and networking.
- Add AWS budgets and cost anomaly detection.
- Add operational runbooks for state, RDS, Valkey, and DNS.
- Add DNS record management when application endpoints exist.

## Later

- Evaluate AWS Organizations and separate AWS accounts.
- Add production-grade observability and incident response documentation.
- Add package repository support through CodeArtifact if npm or NuGet are required.
- Evaluate customer-managed KMS keys if compliance requirements justify the cost.
