# name: Raul Pena (raul.pena@gmail.com)
# createAt: 2026-08-02T17:53:34-0300
# Description: Output values exported by the reusable networking module.

# Identifier of the created VPC
output "vpc_id" {
  description = "VPC ID."
  value       = aws_vpc.this.id
}

# Primary IPv4 CIDR block assigned to the VPC
output "vpc_cidr" {
  description = "VPC CIDR block."
  value       = aws_vpc.this.cidr_block
}

# Map of public subnet IDs indexed by Availability Zone
output "public_subnet_ids" {
  description = "Public subnet IDs by Availability Zone."
  value       = { for az, subnet in aws_subnet.public : az => subnet.id }
}

# Map of private services subnet IDs indexed by Availability Zone
output "services_subnet_ids" {
  description = "Private services subnet IDs by Availability Zone."
  value       = { for az, subnet in aws_subnet.services : az => subnet.id }
}

# Map of private data subnet IDs indexed by Availability Zone
output "data_subnet_ids" {
  description = "Private data subnet IDs by Availability Zone."
  value       = { for az, subnet in aws_subnet.data : az => subnet.id }
}

# Route table ID for public subnets
output "public_route_table_id" {
  description = "Public route table ID."
  value       = aws_route_table.public.id
}

# Map of services route table IDs indexed by Availability Zone
output "services_route_table_ids" {
  description = "Private services route table IDs by Availability Zone."
  value       = { for az, route_table in aws_route_table.services : az => route_table.id }
}

# Map of isolated data route table IDs indexed by Availability Zone
output "data_route_table_ids" {
  description = "Private data route table IDs by Availability Zone."
  value       = { for az, route_table in aws_route_table.data : az => route_table.id }
}

# Default security group ID for private services tier workloads
output "services_security_group_id" {
  description = "Security group ID intended for private services workloads."
  value       = aws_security_group.services.id
}
