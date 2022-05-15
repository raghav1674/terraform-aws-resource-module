resource "aws_alb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = var.listener_port
  protocol          = var.listener_protocol
  certificate_arn   = var.certificate_arn
  default_action {
    target_group_arn = var.default_target_group_arn
    type             = "forward"
  }
}
