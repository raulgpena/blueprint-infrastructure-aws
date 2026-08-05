# name: Raul Pena (raul.pena@gmail.com)
# createAt: 2026-08-04T21:50:02-0300
# Description: Output values exported by the reusable SSM port-forwarding host module.

output "instance_id" {
  description = "EC2 instance ID for SSM Session Manager port forwarding."
  value       = aws_instance.this.id
}

output "instance_private_ip" {
  description = "Private IP address of the SSM helper instance."
  value       = aws_instance.this.private_ip
}

output "ssm_endpoint_ids" {
  description = "SSM interface endpoint IDs by service name."
  value       = { for service, endpoint in aws_vpc_endpoint.ssm : service => endpoint.id }
}
