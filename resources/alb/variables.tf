variable "name" {
  type        = string
  description = "Name of the ALB"
}

variable "internal" {
  type        = bool
  description = "Whether the ALB is internal or external"
  default     = false
}

variable "alb_security_groups" {
  type        = list(string)
  description = "List of security group ids which needs to be attached to the ALB"
}

variable "subnets" {
  type        = list(string)
  description = "List of subnet ids to attach to"
}

variable "enable_deletion_protection" {
  type = bool
  description = "Whether to enable deletion protection or not"
  default = false
}


variable "listener_port" {
  type = number 
  description = "ALB Listener Port"
}

variable "listener_protocol" {
  type = string 
  description = "ALB Listener Protocol"
}

variable "certificate_arn" {
  type = string 
  description = "ACM Certificate ARN"
}

variable "default_target_group_arn" {
  type = string 
  description = "ARN of the target group for default action"
}

variable "environment" {
  type = string
  description = "Environment"
  
}