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
  type        = bool
  description = "Whether to enable deletion protection or not"
  default     = false
}


variable "listener_port" {
  type        = number
  description = "ALB Listener Port"
}

variable "listener_protocol" {
  type        = string
  description = "ALB Listener Protocol"
}

variable "default_certificate_arn" {
  type        = string
  description = "Default ACM Certificate ARN"
}

variable "tags" {
  type        = map(string)
  description = "Tags for all the resources"
}

variable "access_log_buckets" {
  type = list(object({
    bucket_name   = string
    bucket_prefix = string
  }))
  description = "Alb access log bucket name and prefix"
  default     = []
}

variable "enable_access_logs" {
  type        = bool
  description = "Whether to enable ALB access logs or not"
  default     = false
}