variable "bucket_name" {
  type        = string
  description = "Name of the S3 bucket"
}

variable "tags" {
  type        = map(string)
  description = "Tags for all resources"
}

variable "enable_versioning" {
  type        = bool
  description = "Whether to enable versioning or not"
  default     = false
}

variable "bucket_acl" {
  type        = string
  description = "Acl for the bucket"
}

variable "enable_bucket_encryption" {
  type        = bool
  description = "Whether to enable encryption or not"
  default     = false
}

variable "kms_master_key_id" {
  type        = string
  description = "Kms master to use to encrypt if not specified and encryption is enabled will use the default aws/s3 master key"
  default     = null
}

variable "s3_bucket_policies" {
  type        = list(string)
  description = "List of s3 bucket policies to be attached to the bucket"
  default     = []
}