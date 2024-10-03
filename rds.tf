resource "aws_rds_cluster" "misp" {
  cluster_identifier      = "misp"
  engine                  = "aurora-mysql"
  engine_version          = "8.0.mysql_aurora.3.05.2"
  availability_zones      = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
  database_name           = "misp"
  backup_retention_period = 7
  preferred_backup_window = "01:00-02:00"

  allocated_storage = 1
  backtrack_window = 0

  copy_tags_to_snapshot = true
  skip_final_snapshot   = true

  db_cluster_parameter_group_name = "default.aurora-mysql8.0"
  db_subnet_group_name = "default-vpc-0434f125e932091fc"

  deletion_protection = true
}