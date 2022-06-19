variable "create_kms_key" {
  type = bool 
  description = "Whether to create kms key for use with sops encryption or not"
  default = false
}

variable "description" {
  type        = string
  description = "Description for KMS Key"
  default = ""
}

variable "deletion_window_in_days" {
  type        = number
  description = "Deletion Window in Days"
  default     = 7
}

variable "enable_key_rotation" {
  type        = bool
  description = "Whether to enable key rotation"
  default     = false
}

variable "iam_policy" {
  type        = string
  description = "JSON IAM Policy to grant access to the key"
  default     = "{}"
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


