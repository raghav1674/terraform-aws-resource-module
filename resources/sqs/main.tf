resource "aws_sqs_queue" "this" {
  name = var.name

  # fifo related config
  fifo_queue                  = var.fifo_queue
  content_based_deduplication = var.fifo_queue ? var.content_based_deduplication: null
  deduplication_scope         = var.fifo_queue ? var.deduplication_scope : null
  fifo_throughput_limit       = var.fifo_queue ? var.fifo_throughput_limit : null

  # common config
  delay_seconds             = var.delay_seconds
  max_message_size          = var.max_message_size
  message_retention_seconds = var.message_retention_seconds
  receive_wait_time_seconds = var.receive_wait_time_seconds
  redrive_policy            = var.redrive_policy
  redrive_allow_policy      = var.redrive_allow_policy
  policy                    = var.queue_iam_access_policy

  # encryption related config
  sqs_managed_sse_enabled           = var.sqs_managed_sse_enabled
  kms_master_key_id                 = var.kms_master_key_id
  kms_data_key_reuse_period_seconds = var.kms_data_key_reuse_period_seconds

  tags = {
    Environment = var.environment
  }
}
