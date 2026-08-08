<!--
name: Raul Pena (raul.pena@gmail.com)
createAt: 2026-08-08T12:01:26-0300
Description: Glossary of infrastructure terms used by the AWS Terraform blueprint.
-->

# Glossary

- **Data subnet tier**: Private subnets used for backend stateful services such as RDS and Valkey.
- **Services subnet tier**: Private subnets used for application workloads such as EKS, ECS, Fargate, or EC2.
- **Public subnet tier**: Subnets with a route to the Internet Gateway, reserved for future public entry points.
- **SSE-S3**: Amazon S3-managed server-side encryption using `AES256`.
- **SSE-KMS**: Server-side encryption using AWS KMS keys.
- **Valkey**: Open-source Redis-compatible cache engine supported by Amazon ElastiCache.
- **RDS**: Amazon Relational Database Service.
- **SSM**: AWS Systems Manager, used here for private Session Manager port forwarding.
- **VPC endpoint**: Private AWS networking path to an AWS service without public internet routing.
- **Native S3 lock file**: Terraform S3 backend locking mechanism available in Terraform `>= 1.10.0`.
- **ADR**: Architecture Decision Record.
