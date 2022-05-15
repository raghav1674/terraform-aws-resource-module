module "alb" {
  source = "../resources/alb"
  name = "ecs-alb"
  internal = false 
  alb_security_groups = [""]
  subnets = [""]
  enable_deletion_protection = false
  listener_port = 443 
  listener_protocol = "HTTPS"
  certificate_arn = ""
  environment =  "dev"
}

module "ip_target_group"{

    source = "../resources/target-group/ip-target-group"
    target_group_name = "ecs-tg"
    target_group_port =  80  
    target_group_protocol = "HTTP"
    vpc_id = ""
    health_check_interval = 120
    health_check_protocol = "HTTP"
    health_check_path = "/health"
    health_check_status_code_range = "200-399"
    health_check_timeout = 60 
    healthy_threshold = 4
    unhealthy_threshold = 3
    lb_listener_arn  = module.alb.listener_arn
    listener_path_pattern = "/ecs-service"
    listener_rule_priority = 2
    environment = "dev"
}