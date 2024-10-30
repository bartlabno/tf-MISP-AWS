data "aws_iam_policy_document" "ecs_task_execution_assume_role_policy" {
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "misp_ecs_task_role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_assume_role_policy.json
}

data "aws_iam_policy" "ecs_task_execution" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = data.aws_iam_policy.ecs_task_execution.arn
}

resource "aws_iam_role_policy" "password_policy_secretsmanager" {
  name = "password-policy-secretsmanager"
  role = aws_iam_role.ecs_task_execution_role.id

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "secretsmanager:GetSecretValue",
          "ssm:GetParameters"
        ],
        "Effect": "Allow",
        "Resource": [
          "${aws_secretsmanager_secret.db_password.arn}",
          "${aws_secretsmanager_secret.security_extras.arn}",
          "${aws_secretsmanager_secret.api_users.arn}",
          "${aws_secretsmanager_secret.smtp.arn}"
        ]
      }
    ]
  }
  EOF
}

resource "aws_ecs_task_definition" "misp" {
  family = "${var.project}-${var.environment}"

  cpu    = 4096
  memory = 16384

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn

  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  container_definitions = jsonencode([
    {
      name      = "${var.project}-${var.environment}"
      image     = "ghcr.io/nukib/misp:${var.image_version}"
      essential = true

      memory         = 16384
      cpu            = 4096
      mountPoints    = []
      systemControls = []
      volumesFrom    = []

      logConfiguration = {
        Logdriver = "awslogs"
        options = {
          awslogs-create-group  = "true"
          awslogs-group         = "/ecs/${var.environment}/${var.project}"
          awslogs-region        = data.aws_region.current.name
          awslogs-stream-prefix = "ecs"
        }
      }

      portMappings = [
        {
          name          = "${var.project}-${var.environment}"
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
          appProtocol   = "http"
        }
      ]
      environment = [
        {
          name  = "JOBBER_CACHE_FEEDS_TIME"
          value = "0 30 */2 * * *"
        },
        {
          name  = "MYSQL_DATABASE"
          value = aws_rds_cluster.misp.database_name
        },
        {
          name  = "REDIS_HOST"
          value = aws_elasticache_cluster.misp.cache_nodes.0.address
        },
        {
          name  = "DATA_DIR"
          value = "./data"
        },
        {
          name  = "PHP_MAX_EXECUTION_TIME"
          value = "3900"
        },
        {
          name  = "SMTP_HOST"
          value = var.environment == "prod" ? "email-smtp.${data.aws_region.current.name}.amazonaws.com" : " "
        },
        {
          name  = "SECURITY_ADVANCED_AUTHKEYS"
          value = "true"
        },
        {
          name  = "MISP_ORG"
          value = var.owner
        },
        {
          name  = "JOBBER_FETCH_FEEDS_TIME"
          value = "0 0 * * * *"
        },
        {
          name  = "MISP_EMAIL"
          value = "${var.project}@${var.base_domain}"
        },
        {
          name  = "MYSQL_HOST"
          value = aws_rds_cluster_instance.misp[0].endpoint
        },
        {
          name  = "PHP_TIMEZONE"
          value = "Europe/London"
        },
        {
          name  = "MISP_BASEURL"
          value = "https://${var.base_domain}"
        },
        {
          name  = "JOBBER_USER_ID"
          value = "6"
        },
        {
          name  = "TIMEZONE"
          value = "Europe/London"
        },
        {
          name  = "PHP_MEMORY_LIMIT"
          value = "16384M"
        },
        {
          name  = "PHP_UPLOAD_MAX_FILESIZE"
          value = "1024M"
        },
        {
          name  = "MISP_EXTERNAL_BASEURL"
          value = "https://${var.base_domain}"
        }
      ]
      secrets = [
        {
          name      = "MISP_UUID"
          valueFrom = "${aws_secretsmanager_secret.security_extras.arn}:MISP_UUID::"
        },
        {
          name      = "MYSQL_LOGIN"
          valueFrom = "${aws_secretsmanager_secret.db_password.arn}:username::"
        },
        {
          name      = "MYSQL_PASSWORD"
          valueFrom = "${aws_secretsmanager_secret.db_password.arn}:password::"
        },
        {
          name      = "SECURITY_ENCRYPTION_KEY"
          valueFrom = "${aws_secretsmanager_secret.security_extras.arn}:SECURITY_ENCRYPTION_KEY::"
        },
        {
          name      = "SECURITY_SALT"
          valueFrom = "${aws_secretsmanager_secret.security_extras.arn}:SECURITY_SALT::"
        },
        {
          name      = "SMTP_PASSWORD"
          valueFrom = "${aws_secretsmanager_secret.smtp.arn}:password::"
        },
        {
          name      = "SMTP_USERNAME"
          valueFrom = "${aws_secretsmanager_secret.smtp.arn}:username::"
        }
      ]
    }
  ])
}