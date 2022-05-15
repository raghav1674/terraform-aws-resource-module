resource "aws_sqs_queue" "this" {
  name                        = "${var.name}.fifo"
  fifo_queue                  = true
  content_based_deduplication = var.content_based_deduplication
  deduplication_scope         = var.deduplication_scope
  delay_seconds               = var.delay_seconds
  max_message_size            = var.max_message_size
  message_retention_seconds   = var.message_retention_seconds
  receive_wait_time_seconds   = var.receive_wait_time_seconds
  redrive_policy = var.dead_letter_target_queue_arn != null ? jsonencode({
    deadLetterTargetArn = var.dead_letter_target_queue_arn
    maxReceiveCount     = var.max_receive_count
  }) : null
  redrive_allow_policy = jsonencode({
    redrivePermission = var.redrive_permission,
    sourceQueueArns   = var.source_queue_arns
  })
  policy                            = var.queue_iam_access_policy
  sqs_managed_sse_enabled           = var.sqs_managed_sse_enabled
  kms_master_key_id                 = var.sqs_managed_sse_enabled ? null : var.kms_master_key_id
  kms_data_key_reuse_period_seconds = var.sqs_managed_sse_enabled ? null : var.kms_data_key_reuse_period_seconds

  tags = {
    Environment = var.environment
  }
}
