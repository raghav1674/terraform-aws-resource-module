variable "ecs_cluster_name" {
  type        = string
  description = "Name of the ecs cluster"
}

variable "tags" {
  type        = map(string)
  description = "Tags for all the resources"
}