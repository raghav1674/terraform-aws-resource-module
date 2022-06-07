resource "aws_cloudwatch_log_group" "this" {
  name = "/ecs/${var.service_name}-task"
  tags = var.tags
}