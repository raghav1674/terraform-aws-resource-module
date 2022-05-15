variable "name" {
  type = string 
  description = "Name of the SQS Queue without .fifo"
}

# fifo queue related properties
variable "content_based_deduplication" {
  type = bool
  description = "Enables content-based deduplication for FIFO queues"
}

variable "fifo_throughput_limit" {
  type = string 
  description = "Specifies whether the FIFO queue throughput quota applies to the entire queue or per message group."
  default = "perQueue"
  validation {
    condition     = contains(["perQueue", "perMessageGroupId"], var.fifo_throughput_limit)
    error_message = "Allowed values for input_parameter are \"perQueue\", \"perMessageGroupId\"."
  }
}

variable "deduplication_scope" {
  type = string 
  description = "Specifies whether message deduplication occurs at the message group or queue level."
  default = "queue"
  validation {
    condition     = contains(["messageGroup", "queue"], var.deduplication_scope)
    error_message = "Allowed values for input_parameter are \"messageGroup\", \"queue\"."
  }
}

# common queue configurations
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
}

variable "dead_letter_target_queue_arn" {
  type = string 
  description = "ARN of the dead letter queue"
  default = null
}

variable "max_receive_count" {
  type = number 
  description = "The number of times a consumer tries receiving a message from a queue without deleting it before being moved to the dead-letter queue."
  default = 5
}

variable "redrive_permission" {
  type = string
  description = "Which source queue can use this queue as a dead letter queue"
  validation {
    condition     = contains(["byQueue", "allowAll", "denyAll"], var.redrive_permission)
    error_message = "Allowed values for input_parameter are \"ByQueue\", \"AllowAll\", or \"DenyAll\"."
  }
  default = "denyAll"
}

variable "source_queue_arns" {
  type = list(string)
  description = "ARNs of the source queues (applicable only if the redrive_permission is \"ByQueue\" or \"AllowAll\")"
  default = null
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

