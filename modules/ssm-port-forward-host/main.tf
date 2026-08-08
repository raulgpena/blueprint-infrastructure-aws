# name: Raul Pena (raul.pena@gmail.com)
# createAt: 2026-08-04T21:50:02-0300
# Description: Private EC2 helper for SSM Session Manager port forwarding and required SSM VPC endpoints.

data "aws_region" "current" {}

data "aws_ami" "al2023_x86_64" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-kernel-6.1-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

locals {
  endpoint_services = toset([
    "ssm",
    "ssmmessages",
    "ec2messages",
  ])
}

resource "aws_iam_role" "this" {
  name = "${var.name_prefix}-ssm-db-access"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "this" {
  name = "${var.name_prefix}-ssm-db-access"
  role = aws_iam_role.this.name
}

resource "aws_security_group" "endpoints" {
  name        = "${var.name_prefix}-ssm-endpoints"
  description = "Allow private services workloads to connect to SSM interface endpoints"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = toset(var.endpoint_source_security_group_ids)

    content {
      description     = "HTTPS to SSM endpoint from private services"
      from_port       = 443
      to_port         = 443
      protocol        = "tcp"
      security_groups = [ingress.value]
    }
  }

  tags = {
    Name = "${var.name_prefix}-ssm-endpoints"
  }
}

resource "aws_vpc_endpoint" "ssm" {
  for_each = local.endpoint_services

  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${data.aws_region.current.name}.${each.key}"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.endpoint_subnet_ids
  security_group_ids  = [aws_security_group.endpoints.id]
  private_dns_enabled = true

  tags = {
    Name = "${var.name_prefix}-${each.key}-endpoint"
  }
}

resource "aws_instance" "this" {
  ami                         = data.aws_ami.al2023_x86_64.id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.instance_security_group_ids
  iam_instance_profile        = aws_iam_instance_profile.this.name
  associate_public_ip_address = false

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  credit_specification {
    cpu_credits = "standard"
  }

  root_block_device {
    encrypted   = true
    volume_size = var.root_volume_size
    volume_type = "gp3"
  }

  tags = {
    Name = "${var.name_prefix}-ssm-db-access"
  }

  depends_on = [
    aws_iam_role_policy_attachment.ssm_core,
    aws_vpc_endpoint.ssm,
  ]
}
