<!--
name: Raul Pena (raul.pena@gmail.com)
createAt: 2026-08-08T12:01:26-0300
Description: Current architecture summary for the AWS Terraform infrastructure blueprint.
-->

# Architecture

The current architecture uses one Terraform root per environment and reusable modules for shared infrastructure concerns.

## Environments

- `dev`
- `staging`
- `prod`

Each environment composes the same main building blocks with different defaults for cost, availability, and safety.

## Core Components

- VPC with public, private services, and private data subnet tiers.
- Optional NAT Gateway for private services egress.
- S3 Gateway VPC Endpoint for private S3 access.
- Private PostgreSQL RDS in data subnets.
- Private ElastiCache Valkey in data subnets.
- Dev-only SSM port-forward host for database access.
- Optional S3-backed Maven and Helm repositories.
- Optional Route 53 public hosted zone.
- S3 remote state backend with SSE-S3 and native S3 lock files.

## Access Model

- Application workloads run in services subnets.
- Databases and caches run in data subnets.
- PostgreSQL allows `5432/tcp` only from the services security group.
- Valkey allows `6379/tcp` only from the services security group.
- Developer database access uses SSM Session Manager in dev.
