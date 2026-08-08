# name: Raul Pena (raul.pena@gmail.com)
# createAt: 2026-08-04T21:50:02-0300
# Description: Output values exported by the reusable SSM port-forwarding host module.

# Identifier of the provisioned SSM helper EC2 instance
output "instance_id" {
  description = "EC2 instance ID for SSM Session Manager port forwarding."
  value       = aws_instance.this.id
}

# Private IPv4 address of the SSM helper host
output "instance_private_ip" {
  description = "Private IP address of the SSM helper instance."
  value       = aws_instance.this.private_ip
}

# Map of created SSM interface endpoint IDs indexed by service name
output "ssm_endpoint_ids" {
  description = "SSM interface endpoint IDs by service name."
  value       = { for service, endpoint in aws_vpc_endpoint.ssm : service => endpoint.id }
}
