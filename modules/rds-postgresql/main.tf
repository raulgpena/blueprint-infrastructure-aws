# name: Raul Pena (raul.pena@gmail.com)
# createAt: 2026-08-04T21:24:39-0300
# Description: Private PostgreSQL RDS instance, subnet group, and security group.

resource "aws_db_subnet_group" "this" {
  name        = "${var.name_prefix}-postgresql"
  description = "Private data subnets for ${var.name_prefix} PostgreSQL"
  subnet_ids  = values(var.data_subnet_ids)

  tags = {
    Name = "${var.name_prefix}-postgresql"
  }
}

resource "aws_security_group" "this" {
  name        = "${var.name_prefix}-postgresql"
  description = "Allow PostgreSQL access from approved private services"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = toset(var.allowed_security_group_ids)

    content {
      description     = "PostgreSQL from services security group"
      from_port       = 5432
      to_port         = 5432
      protocol        = "tcp"
      security_groups = [ingress.value]
    }
  }

  egress {
    description = "Allow established outbound database responses"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name_prefix}-postgresql"
  }
}

resource "aws_db_instance" "this" {
  identifier = "${var.name_prefix}-postgresql"

  engine         = "postgres"
  engine_version = var.engine_version
  instance_class = var.instance_class

  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  storage_encrypted     = true
  storage_type          = var.storage_type

  db_name  = var.database_name
  username = var.master_username

  manage_master_user_password = true

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.this.id]
  publicly_accessible    = false
  port                   = 5432

  multi_az                   = var.multi_az
  backup_retention_period    = var.backup_retention_period
  deletion_protection        = var.deletion_protection
  skip_final_snapshot        = var.skip_final_snapshot
  final_snapshot_identifier  = var.skip_final_snapshot ? null : "${var.name_prefix}-postgresql-final"
  auto_minor_version_upgrade = true
  copy_tags_to_snapshot      = true

  performance_insights_enabled = var.performance_insights_enabled
  monitoring_interval          = var.monitoring_interval
}
