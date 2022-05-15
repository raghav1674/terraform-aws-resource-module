variable "target_group_name" {
  type = string
  description = "Name of the Target Group"
}

variable "target_group_port" {
  type = string 
  description = "Target Group Port"
}

variable "target_group_protocol" {
  type = string
  description = "Target Group Protocol"
}

variable "vpc_id" {
  type = string 
  description = "Id of the VPC in which target group to be created"
}

variable "healthy_threshold" {
    type = number
    description = "Number of health checks to pass to be considered as healthy"
  
}

variable "health_check_internal" {
    type = number
    description = "Frequency of Health checks"
}

variable "health_check_protocol" {
    type = number
    description = "Protocol on which to do the health checks"
}

variable "health_check_status_code_range" {
    type = number
    description = "Port on which to do the health checks"
}

variable "health_check_timeout" {
    type = number
    description = "Timeout before performing the health checks"
}

variable "health_check_path" {
    type = number
    description = "Protocol on which to do the health checks"
}

variable "unhealthy_threshold" {
    type = number
    description = "Number of health checks to fail to be considered as unhealthy"
}

variable "listener_arn" {
  type = string 
  description = "ARN of the listener to which to attach the target group with load balancer"
}

variable "listener_rule_priority" {
    type = number 
    description = "Priority of the listener rule"
}

variable "listener_path_pattern" {
    type = string
    description = "Path or endpoint on which the listener will be available"
}

variable "environment" {
    type = string 
    description = "Environment"
}