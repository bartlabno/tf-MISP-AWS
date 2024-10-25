resource "aws_kms_key" "ecs_retention" {
    description             = "ecs_retention"
    deletion_window_in_days = 7
}

resource "aws_service_discovery_http_namespace" "misp" {
    name = var.project
}

resource "aws_cloudwatch_log_group" "ecs_misp" {
    name = "/ecs/${var.project}"
}

resource "aws_ecs_cluster" "misp" {
    name = var.project

    setting {
      name  = "containerInsights"
      value = "enabled"
    }

    configuration {
        execute_command_configuration {
            logging = "DEFAULT"
        }
    }

    service_connect_defaults {
        namespace = aws_service_discovery_http_namespace.misp.arn
    }

    tags = "${tomap({
        "AWS.SSM.AppManager.ECS.Cluster.ARN" = "arn:aws:ecs:eu-west-2:${data.aws_caller_identity.current.account_id}:cluster/misp"
    })}"
}