variable "ecs_cluster_name" {
  type        = string
  description = "Name of the ecs fargate cluster"
}

variable "ecs_cluster_id" {
  type        = string
  description = "Id of the ecs fargate cluster"
}

variable "region" {
  type        = string
  description = "the AWS region in which resources are created"
}

variable "task_definition_name" {
  type        = string
  description = "Name of the task definition"
}

variable "container_cpu" {
  type        = number
  description = "The number of cpu units used by the task"
}

variable "container_memory" {
  type        = number
  description = "The amount (in MiB) of memory used by the task"

}

variable "container_name" {
  type        = string
  description = "Name of the container"
}

variable "container_image" {
  type        = string
  description = "Container Image Url"
}

variable "container_environment_variables" {
  type = list(object({
    name  = string,
    value = string
  }))
  description = "List of Container Environment variables"

}

variable "container_port" {
  type        = number
  description = "Port of container"
}

variable "service_name" {
  type        = string
  description = "Name of the ecs service"

}

variable "task_desired_count" {
  type        = number
  description = "Number of services running in parallel"
  default     = 2
}

variable "minimum_healthy_percent" {
  type        = number
  description = "Minimum Healthy percent of the tasks to be running at a point of time"
  default     = 50
}

variable "maximum_healthy_percent" {
  type        = number
  description = "Maximum Healthy percent of the tasks to be running at a point of time"
  default     = 200
}

variable "health_check_grace_period_seconds" {
  type        = number
  description = "Timeout before health check is performed by the alb tg"
  default     = 160

}

variable "ecs_service_security_groups" {
  type        = list(string)
  description = "Comma separated list of security groups"
}

variable "subnets" {
  type        = list(string)
  description = "List of subnet IDs"
}

variable "aws_alb_target_group_arn" {
  type        = string
  description = "ARN of the alb target group"
}

variable "ecs_task_policies" {
  type = list(object({
    name        = string,
    description = string,
    policy      = string
  }))
  description = "List of Policies to be added to the ecs task role"

}

variable "autoscaling_max_capacity" {
  type        = number
  description = "Maximum Number of tasks to be running if autoscaling is enabled"
  default     = 4
}

variable "autoscaling_min_capacity" {
  type        = number
  description = "Minimum Number of tasks to be running if autoscaling is enabled"
  default     = 1
}

variable "autoscaling_memory_target_value" {
  type        = number
  description = "The target Value of Memory usage by container after which scale out can happen"
  default     = 80
}

variable "autoscaling_cpu_target_value" {
  type        = number
  description = "The target Value of CPU usage by container after which scale out can happen"
  default     = 60
}

variable "autoscaling_scale_in_cooldown" {
  type        = number
  description = "Autoscaling Scale In period"
  default     = 300
}

variable "autoscaling_scale_out_cooldown" {
  type        = number
  description = "Autoscaling Scale out period"
  default     = 300
}

variable "autoscaling_enabled" {
  type        = bool
  description = "Decides whether to enable autoscaling for ecs service or not"
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "Tags for the Resources"
  default     = {}
}

variable "enable_loadbalancing" {
  type        = bool
  description = "Whether to enable alb or not"
  default     = false
}
