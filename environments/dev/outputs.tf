# name: Raul Pena (raul.pena@gmail.com)
# createAt: 2026-08-02T17:53:34-0300
# Description: Output values exported by the dev environment root module.

# Export the ID of the created Virtual Private Cloud (VPC) for use by other modules or configurations.
output "vpc_id" {
  description = "VPC ID."
  value       = module.networking.vpc_id
}

# List of private subnet IDs organized by Availability Zone where backend resources will be deployed.
output "private_subnet_ids" {
  description = "Private subnet IDs by Availability Zone."
  value       = module.networking.private_subnet_ids
}

# List of public subnet IDs organized by Availability Zone for resources that require internet access.
output "public_subnet_ids" {
  description = "Public subnet IDs by Availability Zone."
  value       = module.networking.public_subnet_ids
}
