resource "aws_lb" "this" {
  name               = var.name 
  internal           = var.internal 
  load_balancer_type = "application"
  security_groups    = var.alb_security_groups
  subnets            = var.subnets

  enable_deletion_protection = var.enable_deletion_protection

  tags = {
    Environment = var.environment
  }
}