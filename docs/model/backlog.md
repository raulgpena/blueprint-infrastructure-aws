<!--
name: Raul Pena (raul.pena@gmail.com)
createAt: 2026-08-08T12:01:26-0300
Description: Backlog of outstanding infrastructure and documentation tasks.
-->

# Backlog

- Fix or work around the local AWS provider plugin handshake issue.
- Run `terraform validate` for `dev`, `staging`, and `prod`.
- Run `terraform plan` for each environment with the intended backend and variables.
- Add Terraform security scanning.
- Add CI/CD workflow for infrastructure checks.
- Add ADR files under `docs/model/adr`.
- Decide the compute platform module.
- Add monitoring and alerting.
- Add backup and restore runbooks.
- Decide if Valkey authentication/user groups are required.
- Decide if Route 53 hosted zones are needed outside dev.
- Add `api.momcorp.net` later if required.
- Decide whether `.terraform.lock.hcl` files should be committed per environment.
