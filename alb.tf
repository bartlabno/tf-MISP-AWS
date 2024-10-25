resource "aws_alb" "application_load_balancer" {
  name               = "misp"
  internal           = false
  load_balancer_type = "application"
  subnets            = [data.aws_subnets.public_subnets.ids[0],data.aws_subnets.public_subnets.ids[1],data.aws_subnets.public_subnets.ids[2]]
  security_groups    = [data.aws_security_groups.sgs.ids[0]]
}

resource "aws_lb_target_group" "target_group" {
  name        = "misp"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc

  health_check {
    healthy_threshold   = "3"
    interval            = "300"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    unhealthy_threshold = "2"
  }

}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_alb.application_load_balancer.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.id
  }
}