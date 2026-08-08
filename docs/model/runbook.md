<!--
name: Raul Pena (raul.pena@gmail.com)
createAt: 2026-08-08T12:01:26-0300
Description: Operational runbook for common Terraform and AWS infrastructure tasks.
-->

# Runbook

## Validate Terraform Formatting

```sh
terraform fmt -check -recursive
```

## Initialize An Environment Without Backend

```sh
terraform -chdir=environments/dev init -backend=false
terraform -chdir=environments/staging init -backend=false
terraform -chdir=environments/prod init -backend=false
```

## Validate An Environment

```sh
terraform -chdir=environments/dev validate
```

## Plan Dev

```sh
terraform -chdir=environments/dev init -backend-config=backend.local.hcl
terraform -chdir=environments/dev plan -var-file=terraform.tfvars
```

## Open Dev PostgreSQL Tunnel

```sh
terraform -chdir=environments/dev output -raw postgresql_port_forward_command
```

Run the printed command, then connect to PostgreSQL on `localhost:5432`.

## Retrieve Valkey Endpoint

```sh
terraform output -raw valkey_primary_endpoint_address
terraform output -raw valkey_port
```

Valkey clients must use TLS because in-transit encryption is enabled.

## Validate Documentation

```sh
git diff --check
xmllint --noout INFRASTRUCTURE_DIAGRAM.drawio
```
