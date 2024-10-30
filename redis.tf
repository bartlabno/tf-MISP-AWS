resource "aws_elasticache_cluster" "misp" {
  cluster_id               = "${var.project}-${var.environment}"
  engine                   = "redis"
  node_type                = "cache.r6g.large"
  num_cache_nodes          = var.environment != "prod" ? 1 : 2
  parameter_group_name     = "default.redis7"
  engine_version           = "7.1"
  port                     = 6379
  snapshot_retention_limit = 0

  subnet_group_name = aws_elasticache_subnet_group.misp.name
  security_group_ids = [
    aws_security_group.misp_allow_internal.id
  ]
}

resource "aws_elasticache_subnet_group" "misp" {
  name       = "${var.project}-${var.environment}-cache-subnet"
  subnet_ids = module.vpc-misp.elasticache_subnets
}