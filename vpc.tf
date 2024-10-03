data "aws_vpc" "misp" {
    id = var.vpc
}

data "aws_subnets" "public_subnets" {
    filter {
        name   = "vpc-id"
        values = [data.aws_vpc.misp.id]
    }

    tags = {
        Name = "*public*"
    }

    # filter {
    #     name    = "name"
    #     values  = ["*public*"]
    # }
}