resource "aws_ecs_service" "misp" {
  name            = "${var.project}-${var.environment}"
  cluster         = aws_ecs_cluster.misp.id
  task_definition = "${aws_ecs_task_definition.misp.id}:${aws_ecs_task_definition.misp.revision}"
  desired_count   = 1
  launch_type     = "FARGATE"

  depends_on = [aws_cloudwatch_log_group.ecs_misp]

  enable_ecs_managed_tags = true

  health_check_grace_period_seconds = 120
  propagate_tags                    = "TASK_DEFINITION"

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  wait_for_steady_state = true

  load_balancer {
    container_name   = "${var.project}-${var.environment}"
    container_port   = "80"
    target_group_arn = aws_lb_target_group.target_group.arn
  }

  network_configuration {
    assign_public_ip = false
    security_groups = [
      aws_security_group.misp_allow_internal.id,
      aws_security_group.misp_allow_https.id
    ]
    subnets = module.vpc-misp.private_subnets
  }
}