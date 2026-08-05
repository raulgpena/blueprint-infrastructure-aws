# name: Raul Pena (raul.pena@gmail.com)
# createAt: 2026-08-02T17:53:34-0300
# Description: Reusable AWS VPC networking resources with public, services, and data subnets, routing, NAT, and S3 endpoint support.

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.name_prefix}-vpc"
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.name_prefix}-igw"
  }
}

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

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

resource "aws_eip" "nat" {
  for_each = local.nat_gateway_map

  domain = "vpc"

  tags = {
    Name = "${var.name_prefix}-nat-${each.key}"
  }
}

resource "aws_nat_gateway" "this" {
  for_each = local.nat_gateway_map

  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = aws_subnet.public[each.key].id

  tags = {
    Name = "${var.name_prefix}-nat-${each.key}"
  }

  depends_on = [aws_internet_gateway.this]
}

resource "aws_route_table" "services" {
  for_each = local.az_map

  vpc_id = aws_vpc.this.id

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

resource "aws_route_table_association" "services" {
  for_each = aws_subnet.services

  subnet_id      = each.value.id
  route_table_id = aws_route_table.services[each.key].id
}

resource "aws_route_table" "data" {
  for_each = local.az_map

  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.name_prefix}-data-${each.key}"
    tier = "data"
  }
}

resource "aws_route_table_association" "data" {
  for_each = aws_subnet.data

  subnet_id      = each.value.id
  route_table_id = aws_route_table.data[each.key].id
}

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

data "aws_region" "current" {}
