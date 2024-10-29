resource "aws_db_subnet_group" "misp" {
  name = "${var.project}-db-subnet"
  subnet_ids = [
    data.aws_subnets.private_subnets.ids[0],
    data.aws_subnets.private_subnets.ids[1],
    data.aws_subnets.private_subnets.ids[2],
    data.aws_subnets.public_subnets.ids[0],
    data.aws_subnets.public_subnets.ids[1],
    data.aws_subnets.public_subnets.ids[2]
  ]
}


resource "aws_rds_cluster" "misp" {
  cluster_identifier      = var.project
  engine                  = "aurora-mysql"
  engine_version          = "8.0.mysql_aurora.3.05.2"
  availability_zones      = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
  database_name           = "misp"
  backup_retention_period = 7
  preferred_backup_window = "01:00-02:00"

  vpc_security_group_ids = [
    aws_security_group.misp_allow_internal.id
  ]

  master_username = random_password.db_username.result
  master_password = random_password.db_password.result

  copy_tags_to_snapshot = true
  skip_final_snapshot   = true

  db_cluster_parameter_group_name = "default.aurora-mysql8.0"
  db_subnet_group_name            = aws_db_subnet_group.misp.name

  deletion_protection = true
}

resource "aws_rds_cluster_instance" "misp" {
  count              = var.environment != "prod" ? 1 : 2
  identifier         = "${var.project}-${count.index}"
  cluster_identifier = aws_rds_cluster.misp.id
  engine             = aws_rds_cluster.misp.engine
  engine_version     = aws_rds_cluster.misp.engine_version
  instance_class     = var.environment != "prod" ? "db.r5.large" : "db.r6g.2xlarge"
}