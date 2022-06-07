resource "aws_lb_target_group" "this" {

  name        = var.target_group_name
  port        = var.target_group_port
  protocol    = var.target_group_protocol
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    healthy_threshold   = var.healthy_threshold
    interval            = var.health_check_interval
    protocol            = var.health_check_protocol
    matcher             = var.health_check_status_code_range
    timeout             = var.health_check_timeout
    path                = var.health_check_path
    unhealthy_threshold = var.unhealthy_threshold
  }

  tags = var.tags
}
