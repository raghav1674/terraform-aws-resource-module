variable "ecr_repository_name" {
  type        = string
  description = "Name of the ecr repository"
}

variable "image_tag_mutability" {
  type        = string
  description = "Image Tag Mutability"
  default     = "IMMUTABLE"
}

variable "enable_image_scanning" {
  type        = bool
  description = "Whether to enable image scanning on push or not"
  default     = true
}

variable "encryption_type" {
  type        = string
  description = "The encryption type to use for the repository"
  default     = null
}

variable "kms_key" {
  type        = string
  description = "The ARN of the KMS key to use when encryption_type is KMS."
  default     = null
}


variable "create_ecr_repository_policy" {
  type        = bool
  description = "Whether to create ecr repository policy or not"
  default     = false
}

variable "aws_ecr_repository_policy_document" {
  type        = string
  description = "The JSON Policy to be attached to the repository"
  default     = null
}

variable "tags" {
  type = map(string)
  description = "Tags for all resources"
  default = {}
}