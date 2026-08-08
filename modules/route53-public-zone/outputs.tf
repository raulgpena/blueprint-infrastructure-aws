# name: Raul Pena (raul.pena@gmail.com)
# createAt: 2026-08-08T10:25:30-0300
# Description: Output values exported by the reusable Route 53 public hosted zone module.

output "zone_id" {
  description = "Route 53 public hosted zone ID."
  value       = try(aws_route53_zone.this[0].zone_id, null)
}

output "name_servers" {
  description = "Route 53 name servers to configure at the external domain registrar."
  value       = try(aws_route53_zone.this[0].name_servers, [])
}

output "domain_name" {
  description = "Hosted zone domain name."
  value       = try(aws_route53_zone.this[0].name, null)
}
