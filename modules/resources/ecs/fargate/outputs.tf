output "service_name" {
  value = aws_ecs_service.this.name
}
output "service_id" {
  value = aws_ecs_service.this.id
}
output "task_defintion_arn" {
  value = aws_ecs_task_definition.this.arn
}
output "task_defintion" {
  value = aws_ecs_task_definition.this.container_definitions
}
output "task_execution_role_arn" {
  value = aws_iam_role.ecs_task_execution_role.arn
}
output "task_role_arn" {
  value = aws_iam_role.ecs_task_role.arn
}
output "cloudwatch_log_group_arn" {
  value = aws_cloudwatch_log_group.this.arn
}
