resource "aws_elasticache_cluster" "misp-001" {
  cluster_id               = "${var.project}-001"
  engine                   = "redis"
  node_type                = "cache.r6g.large"
  num_cache_nodes          = 1
  parameter_group_name     = "default.redis7"
  engine_version           = "7.1"
  port                     = 6379
  snapshot_retention_limit = 0
}

resource "aws_elasticache_cluster" "misp-002" {
  cluster_id               = "${var.project}-002"
  engine                   = "redis"
  node_type                = "cache.r6g.large"
  num_cache_nodes          = 1
  parameter_group_name     = "default.redis7"
  engine_version           = "7.1"
  port                     = 6379
  snapshot_retention_limit = 1
}