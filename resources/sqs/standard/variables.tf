variable "name" {
  type = string 
  description = "Name of the SQS Queue"
}

variable "delay_seconds" {
  type = number 
  description = "The time in seconds that the delivery of all messages in the queue will be delayed"
  default = 90
}

variable "max_message_size" {
  type = number 
  description = "Maximum sqs payload size in bytes"
  default = 2048
}

variable "message_retention_seconds" {
    type = number
    description = "The number of seconds Amazon SQS retains a message in seconds."
    default = 345600
}

variable "receive_wait_time_seconds" {
  type = number 
  description = "The time for which a ReceiveMessage call will wait for a message to arrive (long polling) before returning."
  default = 0
}

variable "queue_iam_access_policy" {
  type = string 
  description = "The JSON policy for the SQS queue."
  default = null
}

variable "redrive_allow_policy" {
  type = string 
  description = "The JSON policy to set up the Dead Letter Queue redrive permission."
  default = ""
}

variable "redrive_policy" {
  type = string 
  description = "The JSON policy to set up the Dead Letter Queue."
  default = ""
}

variable "sqs_managed_sse_enabled" {
  type = bool 
  description = "Boolean to enable server-side encryption (SSE) of message content with SQS-owned encryption keys."
  default = false
}

variable "kms_master_key_id" {
  type = string 
  description = "The ID of an AWS-managed customer master key (CMK) for Amazon SQS or a custom CMK"
  default = null
}

variable "kms_data_key_reuse_period_seconds" {
  type = number 
  description = "The length of time, in seconds, for which Amazon SQS can reuse a data key to encrypt or decrypt messages before calling AWS KMS again"
  default = 300
}


variable "environment" {
  type = string 
  description = "Environment"
}