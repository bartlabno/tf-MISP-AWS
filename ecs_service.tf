resource "aws_ecs_service" "misp" {
    name = var.project
    cluster = aws_ecs_cluster.misp.id
    task_definition = "${aws_ecs_task_definition.misp.id}:${aws_ecs_task_definition.misp.revision}"
    desired_count = 1

    enable_ecs_managed_tags = true

    health_check_grace_period_seconds = 120
    propagate_tags = "TASK_DEFINITION"

    deployment_circuit_breaker {
        enable = true
        rollback = true
    }

    wait_for_steady_state = true

    load_balancer {
        container_name = var.project
        container_port = "80"
        target_group_arn = "arn:aws:elasticloadbalancing:eu-west-2:779799343306:targetgroup/misp/da4d0311f440085c"
    }

    network_configuration {
        assign_public_ip = true
        security_groups = [
            "sg-099a8afc0dcdbe1e4",
            "sg-0d08b5d03f5faa340"
        ]
        subnets = [
            "subnet-02a0882b3e4c86373",
            "subnet-08919d492ab1448af",
            "subnet-096f4e8156c027d19"
        ]
    }
}