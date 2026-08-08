# name: Raul Pena (raul.pena@gmail.com)
# createAt: 2026-08-02T17:53:34-0300
# Description: Reusable AWS VPC networking resources with public, services, and data subnets, routing, NAT, and S3 endpoint support.

# Main Virtual Private Cloud (VPC)
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.name_prefix}-vpc"
  }
}

# Base security group for services layer workloads
resource "aws_security_group" "services" {
  name        = "${var.name_prefix}-services"
  description = "Security group for private services workloads"
  vpc_id      = aws_vpc.this.id

  # Allow all outbound traffic
  egress {
    description = "Allow outbound traffic from services workloads"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name_prefix}-services"
    tier = "services"
  }
}

# Internet Gateway for public subnet ingress and egress
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.name_prefix}-igw"
  }
}

# Public subnets across configured availability zones
resource "aws_subnet" "public" {
  for_each = local.az_map

  vpc_id                  = aws_vpc.this.id
  availability_zone       = each.key
  cidr_block              = cidrsubnet(var.vpc_cidr, var.public_subnet_newbits, each.value.index)
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.name_prefix}-public-${each.key}"
    tier = "public"
  }
}

# Private services subnets across configured availability zones
resource "aws_subnet" "services" {
  for_each = local.az_map

  vpc_id            = aws_vpc.this.id
  availability_zone = each.key
  cidr_block        = cidrsubnet(var.vpc_cidr, var.services_subnet_newbits, each.value.index + length(var.availability_zones))

  tags = {
    Name = "${var.name_prefix}-services-${each.key}"
    tier = "services"
  }
}

# Isolated private data subnets across configured availability zones
resource "aws_subnet" "data" {
  for_each = local.az_map

  vpc_id            = aws_vpc.this.id
  availability_zone = each.key
  cidr_block        = cidrsubnet(var.vpc_cidr, var.data_subnet_newbits, each.value.index + (length(var.availability_zones) * 2))

  tags = {
    Name = "${var.name_prefix}-data-${each.key}"
    tier = "data"
  }
}

# Route table directing public traffic to the Internet Gateway
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "${var.name_prefix}-public"
    tier = "public"
  }
}

# Associate public subnets with the public route table
resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

# Elastic IP allocation for NAT Gateway(s)
resource "aws_eip" "nat" {
  for_each = local.nat_gateway_map

  domain = "vpc"

  tags = {
    Name = "${var.name_prefix}-nat-${each.key}"
  }
}

# NAT Gateway(s) in public subnets for outbound internet from private subnets
resource "aws_nat_gateway" "this" {
  for_each = local.nat_gateway_map

  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = aws_subnet.public[each.key].id

  tags = {
    Name = "${var.name_prefix}-nat-${each.key}"
  }

  depends_on = [aws_internet_gateway.this]
}

# Route tables for private services subnets with optional NAT route
resource "aws_route_table" "services" {
  for_each = local.az_map

  vpc_id = aws_vpc.this.id

  # Conditionally route outbound internet traffic through the appropriate NAT Gateway
  dynamic "route" {
    for_each = var.enable_nat_gateway ? [1] : []

    content {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = var.single_nat_gateway ? aws_nat_gateway.this[var.availability_zones[0]].id : aws_nat_gateway.this[each.key].id
    }
  }

  tags = {
    Name = "${var.name_prefix}-services-${each.key}"
    tier = "services"
  }
}

# Associate services subnets with their respective route tables
resource "aws_route_table_association" "services" {
  for_each = aws_subnet.services

  subnet_id      = each.value.id
  route_table_id = aws_route_table.services[each.key].id
}

# Isolated route tables for private data tier subnets (no NAT route)
resource "aws_route_table" "data" {
  for_each = local.az_map

  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.name_prefix}-data-${each.key}"
    tier = "data"
  }
}

# Associate data subnets with their respective isolated route tables
resource "aws_route_table_association" "data" {
  for_each = aws_subnet.data

  subnet_id      = each.value.id
  route_table_id = aws_route_table.data[each.key].id
}

# Gateway VPC Endpoint for direct, private S3 traffic routing
resource "aws_vpc_endpoint" "s3" {
  count = var.enable_s3_endpoint ? 1 : 0

  vpc_id            = aws_vpc.this.id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = concat(values(aws_route_table.services)[*].id, values(aws_route_table.data)[*].id)

  tags = {
    Name = "${var.name_prefix}-s3-endpoint"
  }
}

# Fetch current AWS region for VPC endpoint configuration
data "aws_region" "current" {}
