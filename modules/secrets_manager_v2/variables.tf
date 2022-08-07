variable "description" {
  type        = string
  description = "Description for KMS Key"
  default = ""
}

variable "tags" {
  type        = map(string)
  description = "Tags for all resources"
  default     = {}
}


variable "service_name" {
  type        = string
  description = "Name of the service who is using the secrets"
}

variable "env_name" {
  type = string
  description = "Environment Name for which the secrets are kept eg dev,qa"
}

