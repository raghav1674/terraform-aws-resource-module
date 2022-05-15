resource "aws_lb_listener_rule" "this" {
  listener_arn = var.lb_listener_arn
  priority     = var.listener_rule_priority

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.this.arn

    condition {
      path_pattern {
        values = var.listener_path_pattern
      }
    }
  }
}
