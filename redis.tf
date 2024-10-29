resource "aws_elasticache_cluster" "misp" {
  cluster_id               = var.project
  engine                   = "redis"
  node_type                = "cache.r6g.large"
  num_cache_nodes          = var.environment != "prod" ? 1 : 2
  parameter_group_name     = "default.redis7"
  engine_version           = "7.1"
  port                     = 6379
  snapshot_retention_limit = 0

  subnet_group_name  = aws_elasticache_subnet_group.misp.name
  security_group_ids = [data.aws_security_groups.default.ids[0]]
}

resource "aws_elasticache_subnet_group" "misp" {
  name = "${var.project}-cache-subnet"
  subnet_ids = [
    data.aws_subnets.private_subnets.ids[0],
    data.aws_subnets.private_subnets.ids[1],
    data.aws_subnets.private_subnets.ids[2],
    data.aws_subnets.public_subnets.ids[0],
    data.aws_subnets.public_subnets.ids[1],
    data.aws_subnets.public_subnets.ids[2]
  ]
}