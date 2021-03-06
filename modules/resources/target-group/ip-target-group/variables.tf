variable "target_group_name" {
  type        = string
  description = "Name of the Target Group"
}

variable "target_group_port" {
  type        = string
  description = "Target Group Port"
}

variable "target_group_protocol" {
  type        = string
  description = "Target Group Protocol"
}

variable "vpc_id" {
  type        = string
  description = "Id of the VPC in which target group to be created"
}

variable "healthy_threshold" {
  type        = number
  description = "Number of health checks to pass to be considered as healthy"

}

variable "health_check_interval" {
  type        = number
  description = "Frequency of Health checks"
}

variable "health_check_protocol" {
  type        = string
  description = "Protocol on which to do the health checks"
}

variable "health_check_status_code_range" {
  type        = string
  description = "Port on which to do the health checks"
}

variable "health_check_timeout" {
  type        = number
  description = "Timeout before performing the health checks"
}

variable "health_check_path" {
  type        = string
  description = "Health check path"
}

variable "unhealthy_threshold" {
  type        = number
  description = "Number of health checks to fail to be considered as unhealthy"
}

variable "listener_rule_priority" {
  type        = number
  description = "Priority of the listener rule"
}

variable "listener_path_patterns" {
  type        = list(string)
  description = "List of Path on which the tg will be available"
}

variable "lb_listener_arn" {
  type        = string
  description = "ARN of the listener"
}

variable "tags" {
  type        = map(string)
  description = "Tags for the Resources"
  default     = {}
}