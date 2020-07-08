resource "aws_lb_listener" "environment_no_https" {
  load_balancer_arn = var.lb_arn
  port              = var.lb_port
  protocol          = var.lb_protocol

  default_action {
    target_group_arn = var.target_group_arn
    type             = "forward"
  }
}

