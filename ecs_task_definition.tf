resource "aws_ecs_task_definition" "misp" {
    family = var.project

    cpu = 4096
    memory = 16384
    
    execution_role_arn = "arn:aws:iam::779799343306:role/EcsMispTaskExecutionRole"
    
    requires_compatibilities = ["FARGATE"]

    runtime_platform {
        operating_system_family = "LINUX"
        cpu_architecture        = "X86_64"
    }

    container_definitions = jsonencode([
        {
        name    = var.project
        image   = "${aws_ecr_repository.misp.repository_url}:${var.image_version}"
        essential = true
    
        memoryReservation  = 16384
        network_mode = "awsvpc"
        mountPoints = []
        systemControls = []
        volumesFrom = []

        logConfiguration = {
                Logdriver = "awslogs"
                options = {
                    awslogs-create-group = "true"
                    awslogs-group = "/ecs/misp"
                    awslogs-region = "eu-west-2"
                    awslogs-stream-prefix = "ecs"
                }
            }

        portMappings = [
            {
                name = var.project
                containerPort = 80
                hostPort = 80
                protocol = "tcp"
                appProtocol = "http"
            }
        ]
        environment = [
            {
                name  = "JOBBER_CACHE_FEEDS_TIME"
                value = "0 30 */2 * * *"
            },
            {
                name  = "MYSQL_DATABASE"
                value = "misp"
            },
            {
                name  = "REDIS_HOST"
                value = "misp-001.sq8sub.0001.euw2.cache.amazonaws.com"
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
                value = "email-smtp.eu-west-2.amazonaws.com"
            },
            {
                name  = "SECURITY_ADVANCED_AUTHKEYS"
                value = "true"
            },
            {
                name  = "MISP_ORG"
                value = "GDS"
            },
            {
                name  = "JOBBER_FETCH_FEEDS_TIME"
                value = "0 0 * * * *"
            },
            {
                name  = "MISP_EMAIL"
                value = "misp@cyber-security.digital.cabinet-office.gov.uk"
            },
            {
                name  = "MYSQL_HOST"
                value = "misp-instance-1.cehvnmppczqy.eu-west-2.rds.amazonaws.com"
            },
            {
                name  = "PHP_TIMEZONE"
                value = "Europe/London"
            },
            {
                name  = "MISP_BASEURL"
                value = "https://misp.cyber-security.digital.cabinet-office.gov.uk"
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
                value = "https://misp.cyber-security.digital.cabinet-office.gov.uk"
            }
        ]
        secrets = [
            {
                name        = "MISP_UUID"
                valueFrom   = "arn:aws:secretsmanager:eu-west-2:779799343306:secret:prod/misp/security_extras-JT6ClN:MISP_UUID::"
            },
            {
                name        = "MYSQL_LOGIN"
                valueFrom   = "arn:aws:secretsmanager:eu-west-2:779799343306:secret:rds!cluster-7ca9d9f3-e6cb-4c20-bcb2-8aeb1ff05dd8-NjAVK6:username::"
            },
            {
                name        = "MYSQL_PASSWORD"
                valueFrom   = "arn:aws:secretsmanager:eu-west-2:779799343306:secret:rds!cluster-7ca9d9f3-e6cb-4c20-bcb2-8aeb1ff05dd8-NjAVK6:password::"
            },
            {
                name        = "SECURITY_ENCRYPTION_KEY"
                valueFrom   = "arn:aws:secretsmanager:eu-west-2:779799343306:secret:prod/misp/security_extras-JT6ClN:SECURITY_ENCRYPTION_KEY::"
            },
            {
                name        = "SECURITY_SALT"
                valueFrom   = "arn:aws:secretsmanager:eu-west-2:779799343306:secret:prod/misp/security_extras-JT6ClN:SECURITY_SALT::"
            },
            {
                name        = "SMTP_PASSWORD"
                valueFrom   = "arn:aws:secretsmanager:eu-west-2:779799343306:secret:prod/misp/smtp_credentials-a8UjoK:smtp_password::"
            },
            {
                name        = "SMTP_USERNAME"
                valueFrom   = "arn:aws:secretsmanager:eu-west-2:779799343306:secret:prod/misp/smtp_credentials-a8UjoK:smtp_username::"
            }
        ]
        }
    ])
}