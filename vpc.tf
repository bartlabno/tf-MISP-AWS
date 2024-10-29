data "aws_vpc" "misp" {
  id = var.vpc
}

data "aws_subnets" "public_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.misp.id]
  }

  filter {
    name   = "tag:Name"
    values = ["*public*"]
  }
}

data "aws_subnets" "private_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.misp.id]
  }

  filter {
    name   = "tag:Name"
    values = ["*private*"]
  }
}

data "aws_security_groups" "misp" {
  filter {
    name   = "vpc-id"
    values = [var.vpc]
  }

  filter {
    name   = "group-name"
    values = ["*misp*"]
  }
}

data "aws_security_groups" "default" {
  filter {
    name   = "vpc-id"
    values = [var.vpc]
  }

  filter {
    name   = "group-name"
    values = ["*default*"]
  }
}