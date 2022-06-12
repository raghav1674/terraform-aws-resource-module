resource "aws_lb" "this" {
  name               = var.name
  internal           = var.internal
  load_balancer_type = "application"
  security_groups    = var.alb_security_groups
  subnets            = var.subnets

  enable_deletion_protection = var.enable_deletion_protection

  dynamic "access_logs" {

    for_each = var.access_log_buckets
    content {
      bucket  = access_logs.value["bucket_name"]
      prefix  = access_logs.value["bucket_prefix"]
      enabled = var.enable_access_logs
    }
  }
  tags = var.tags
}
