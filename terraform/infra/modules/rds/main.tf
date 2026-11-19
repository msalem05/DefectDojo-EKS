resource "aws_db_instance" "postgresql" {
  allocated_storage               = var.minimum_storage
  max_allocated_storage           = var.maximum_storage
  db_name                         = var.db_name
  engine                          = "postgres"
  engine_version                  = var.db_engine_version
  instance_class                  = var.instance_class
  storage_encrypted               = true
  username                        = "mohammedsalem"
  maintenance_window              = var.maintenance_window
  backup_retention_period         = var.backup_retention_period
  final_snapshot_identifier       = "${var.final_snapshot}-${formatdate("YYYYMMDDhhmmss", timestamp())}"
  auto_minor_version_upgrade      = true
  manage_master_user_password     = true
  performance_insights_enabled    = true
  enabled_cloudwatch_logs_exports = var.cloudwatch_exports
  vpc_security_group_ids          = [var.db_sg_id]
  db_subnet_group_name            = aws_db_subnet_group.private.name
}

resource "aws_db_subnet_group" "private" {
  name       = var.subnet_group_name
  subnet_ids = var.subnet_ids
}