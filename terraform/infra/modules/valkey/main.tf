resource "aws_elasticache_replication_group" "valkey" {
  engine                     = "valkey"
  replication_group_id       = var.replication_group_id
  description                = "Valkey replication group for Defect Dojo caching layer"
  security_group_ids         = [var.valkey_sg_id]
  node_type                  = var.node_type
  num_cache_clusters         = var.num_cache_clusters
  transit_encryption_enabled = true
  transit_encryption_mode    = "preferred"
  subnet_group_name          = aws_elasticache_subnet_group.private.name
}

resource "aws_elasticache_subnet_group" "private" {
  name       = var.subnet_group_name
  subnet_ids = var.private_subnet_id
}

resource "aws_ssm_parameter" "valkey_endpoint" {
  name        = "/defectdojo/valkey/endpoint"
  description = "ElastiCache Valkey primary endpoint for celery worker deployment"
  type        = "String"

  value = aws_elasticache_replication_group.valkey.primary_endpoint_address
}