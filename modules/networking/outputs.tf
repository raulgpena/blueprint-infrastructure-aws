# name: Raul Pena (raul.pena@gmail.com)
# createAt: 2026-08-02T17:53:34-0300
# Description: Output values exported by the reusable networking module.

output "vpc_id" {
  description = "VPC ID."
  value       = aws_vpc.this.id
}

output "vpc_cidr" {
  description = "VPC CIDR block."
  value       = aws_vpc.this.cidr_block
}

output "public_subnet_ids" {
  description = "Public subnet IDs by Availability Zone."
  value       = { for az, subnet in aws_subnet.public : az => subnet.id }
}

output "services_subnet_ids" {
  description = "Private services subnet IDs by Availability Zone."
  value       = { for az, subnet in aws_subnet.services : az => subnet.id }
}

output "data_subnet_ids" {
  description = "Private data subnet IDs by Availability Zone."
  value       = { for az, subnet in aws_subnet.data : az => subnet.id }
}

output "public_route_table_id" {
  description = "Public route table ID."
  value       = aws_route_table.public.id
}

output "services_route_table_ids" {
  description = "Private services route table IDs by Availability Zone."
  value       = { for az, route_table in aws_route_table.services : az => route_table.id }
}

output "data_route_table_ids" {
  description = "Private data route table IDs by Availability Zone."
  value       = { for az, route_table in aws_route_table.data : az => route_table.id }
}
