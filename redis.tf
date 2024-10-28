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

resource "aws_elasticache_subnet_group" "misp" {
  name       = "${var.project}-cache-subnet"
  subnet_ids = [data.aws_subnets.private_subnets.*.id]
}

resource "aws_elasticache_replication_group" "misp" {
  replication_group_id = var.project

  node_type            = "cache.r6g.large"
  port                 = 6379
  parameter_group_name = "default.redis7.cluster.on"
  engine_version       = "7.1"

  snapshot_retention_limit = var.environment != "prod" ? 1 : 3
  snapshot_window          = "00:00-05:00"

  subnet_group_name          = aws_elasticache_subnet_group.misp.name
  automatic_failover_enabled = true

  cluster_mode {
    replicas_per_node_group = var.environment != "prod" ? 1 : 2
    num_node_groups         = 1
  }
}