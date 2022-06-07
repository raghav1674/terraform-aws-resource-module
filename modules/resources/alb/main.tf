resource "aws_lb" "this" {
  name               = var.name
  internal           = var.internal
  load_balancer_type = "application"
  security_groups    = var.alb_security_groups
  subnets            = var.subnets

  enable_deletion_protection = var.enable_deletion_protection

  access_logs {
    bucket  = var.access_log_bucket.name
    prefix  = var.access_log_bucket.prefix
    enabled = var.enable_access_logs
  }

  tags = var.tags
}