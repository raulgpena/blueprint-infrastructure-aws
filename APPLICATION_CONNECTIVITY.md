<!--
name: Raul Pena (raul.pena@gmail.com)
createAt: 2026-08-08T11:40:31-0300
Description: Application connectivity guide for using private RDS PostgreSQL and ElastiCache Valkey from Java and C# services.
-->

# Application Connectivity

This guide explains how an application should connect to the private PostgreSQL RDS database and the private ElastiCache Valkey cache created by this Terraform project.

## Network Model

PostgreSQL and Valkey are private backend services. They are deployed in the `data` subnet tier and are not reachable directly from the internet.

Applications should run in the `services` subnet tier, for example on EKS, ECS, Fargate, or private EC2. The services security group is allowed to connect to:

- PostgreSQL on TCP port `5432`
- Valkey on TCP port `6379`

Developer laptops should not connect directly to the private endpoints. For dev database access, use the SSM port-forwarding helper created by the dev environment.

## Terraform Outputs

After applying an environment, get the service endpoints with:

```sh
terraform output -raw postgresql_endpoint
terraform output -raw postgresql_secret_arn
terraform output -raw valkey_primary_endpoint_address
terraform output -raw valkey_port
```

For dev local PostgreSQL access, get the SSM tunnel command:

```sh
terraform output -raw postgresql_port_forward_command
```

Run the printed command, then connect your local database client to `localhost:5432`.

## Secrets

Do not commit passwords, connection strings with passwords, or cache credentials to Git.

For applications running in AWS, prefer one of these patterns:

- Read the RDS password from AWS Secrets Manager.
- Inject secrets as environment variables from a deployment system.
- Use External Secrets or a similar controller for Kubernetes workloads.

For local development, retrieve the RDS password from the `postgresql_secret_arn` value in AWS Secrets Manager.

## PostgreSQL From Java

For Spring Boot, configure PostgreSQL with environment variables:

```yaml
spring:
  datasource:
    url: jdbc:postgresql://${DB_HOST}:${DB_PORT:5432}/${DB_NAME}
    username: ${DB_USERNAME}
    password: ${DB_PASSWORD}
```

Example environment values inside AWS:

```sh
DB_HOST=blueprint-dev-postgresql.xxxxxx.us-east-1.rds.amazonaws.com
DB_PORT=5432
DB_NAME=appdb
DB_USERNAME=appadmin
DB_PASSWORD=<read from Secrets Manager>
```

Example local dev values when the SSM port-forward tunnel is running:

```sh
DB_HOST=localhost
DB_PORT=5432
DB_NAME=appdb
DB_USERNAME=appadmin
DB_PASSWORD=<read from Secrets Manager>
```

Use the PostgreSQL JDBC driver in the application build:

```xml
<dependency>
  <groupId>org.postgresql</groupId>
  <artifactId>postgresql</artifactId>
</dependency>
```

## PostgreSQL From C#

For .NET, use a connection string from configuration or environment variables:

```json
{
  "ConnectionStrings": {
    "PostgreSQL": "Host=${DB_HOST};Port=${DB_PORT};Database=${DB_NAME};Username=${DB_USERNAME};Password=${DB_PASSWORD};SSL Mode=Require;Trust Server Certificate=true"
  }
}
```

Example package:

```sh
dotnet add package Npgsql
```

Example usage:

```csharp
using Npgsql;

var connectionString = builder.Configuration.GetConnectionString("PostgreSQL");
await using var connection = new NpgsqlConnection(connectionString);
await connection.OpenAsync();
```

For production, validate the TLS certificate chain instead of relying on `Trust Server Certificate=true`.

## Valkey From Java

Valkey is Redis-compatible for common cache use cases. Because this infrastructure enables in-transit encryption, clients must use TLS.

For Spring Boot with Redis-compatible cache support:

```yaml
spring:
  data:
    redis:
      host: ${CACHE_HOST}
      port: ${CACHE_PORT:6379}
      ssl:
        enabled: true
```

Example environment values:

```sh
CACHE_HOST=blueprint-dev-valkey.xxxxxx.use1.cache.amazonaws.com
CACHE_PORT=6379
```

Typical Java client libraries include Lettuce and Jedis. Spring Boot uses Lettuce by default in many configurations.

## Valkey From C#

For .NET, use a Redis-compatible client such as `StackExchange.Redis`.

Example package:

```sh
dotnet add package StackExchange.Redis
```

Example TLS-enabled connection:

```csharp
using StackExchange.Redis;

var cacheHost = Environment.GetEnvironmentVariable("CACHE_HOST");
var cachePort = Environment.GetEnvironmentVariable("CACHE_PORT") ?? "6379";

var options = new ConfigurationOptions
{
    EndPoints = { $"{cacheHost}:{cachePort}" },
    Ssl = true,
    AbortOnConnectFail = false
};

var redis = await ConnectionMultiplexer.ConnectAsync(options);
var database = redis.GetDatabase();

await database.StringSetAsync("healthcheck", "ok", TimeSpan.FromMinutes(5));
var value = await database.StringGetAsync("healthcheck");
```

## Local Redis vs AWS Valkey

Local Redis on a laptop often runs without TLS and without private networking. AWS Valkey in this project is different:

- It is private inside the VPC.
- It allows access only from the services security group.
- It requires TLS when `valkey_transit_encryption_enabled = true`.
- It should be used as a cache, not as the only durable data store.

If an application works locally but fails in AWS, check these first:

- The workload is running in the services subnet tier.
- The workload uses the services security group.
- The cache client has TLS enabled.
- The application is using the Valkey primary endpoint and port from Terraform outputs.
- The database password is being loaded from the approved secret source.

## Recommended Application Environment Variables

Use a consistent environment variable contract across Java, C#, and other services:

```sh
DB_HOST=<postgresql endpoint hostname>
DB_PORT=5432
DB_NAME=appdb
DB_USERNAME=appadmin
DB_PASSWORD=<from secret manager>
CACHE_HOST=<valkey primary endpoint hostname>
CACHE_PORT=6379
CACHE_TLS=true
```

Keep these values environment-specific. Dev, staging, and prod should not share database or cache endpoints.
