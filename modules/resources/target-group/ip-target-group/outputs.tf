output "arn" {
  value = aws_lb_target_group.this.arn
}

output "listener_rule_arn" {
  value = aws_lb_listener_rule.this.arn
}
