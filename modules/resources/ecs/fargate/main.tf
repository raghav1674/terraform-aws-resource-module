resource "aws_ecs_service" "this" {
  name                               = var.service_name
  cluster                            = var.ecs_cluster_id
  task_definition                    = aws_ecs_task_definition.this.arn
  desired_count                      = var.task_desired_count
  deployment_minimum_healthy_percent = var.minimum_healthy_percent
  deployment_maximum_percent         = var.maximum_healthy_percent
  health_check_grace_period_seconds  = var.enable_loadbalancing ? var.health_check_grace_period_seconds: null 
  launch_type                        = "FARGATE"
  scheduling_strategy                = "REPLICA"

  network_configuration {
    security_groups  = var.ecs_service_security_groups
    subnets          = var.subnets
    assign_public_ip = var.assign_public_ip
  }

  load_balancer {
    target_group_arn = var.aws_alb_target_group_arn
    container_name   = var.enable_loadbalancing ? var.container_name : null
    container_port   = var.enable_loadbalancing ? var.container_port : null
  }
}
