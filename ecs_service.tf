resource "aws_ecs_service" "misp" {
  name            = var.project
  cluster         = aws_ecs_cluster.misp.id
  task_definition = "${aws_ecs_task_definition.misp.id}:${aws_ecs_task_definition.misp.revision}"
  desired_count   = 1

  enable_ecs_managed_tags = true

  health_check_grace_period_seconds = 120
  propagate_tags                    = "TASK_DEFINITION"

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  wait_for_steady_state = true

  load_balancer {
    container_name   = var.project
    container_port   = "80"
    target_group_arn = aws_lb_target_group.target_group.arn
  }

  network_configuration {
    assign_public_ip = true
    security_groups = [
      data.aws_security_groups.sgs.ids[0]
    ]
    subnets = [data.aws_subnets.public_subnets.ids[0], data.aws_subnets.public_subnets.ids[1], data.aws_subnets.public_subnets.ids[2]]
  }
}