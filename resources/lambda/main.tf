resource "aws_lambda_function" "this" {
  count = var.create_function

  function_name                  = var.function_name
  description                    = var.description

  role                           = var.lambda_role
  handler                        = var.package_type != "Zip" ? null : var.handler
  memory_size                    = var.memory_size
  reserved_concurrent_executions = var.reserved_concurrent_executions
  runtime                        = var.package_type != "Zip" ? null : var.runtime
  layers                         = var.layers
  timeout                        = var.timeout
  publish                        = var.publish
  kms_key_arn                    = var.kms_key_arn
  image_uri                      = var.image_uri
  package_type                   = var.package_type
  architectures                  = var.architectures

  dynamic "ephemeral_storage" {
    for_each = var.ephemeral_storage_size == null ? [] : [true]

    content {
      size = var.ephemeral_storage_size
    }
  }

  filename         = local.filename
  source_code_hash = var.ignore_source_code_hash ? null : (local.filename == null ? false : fileexists(local.filename)) && !local.was_missing ? filebase64sha256(local.filename) : null

  s3_bucket         = local.s3_bucket
  s3_key            = local.s3_key
  s3_object_version = local.s3_object_version

  dynamic "image_config" {
    for_each = length(var.image_config_entry_point) > 0 || length(var.image_config_command) > 0 || var.image_config_working_directory != null ? [true] : []
    content {
      entry_point       = var.image_config_entry_point
      command           = var.image_config_command
      working_directory = var.image_config_working_directory
    }
  }

  dynamic "environment" {
    for_each = length(keys(var.environment_variables)) == 0 ? [] : [true]
    content {
      variables = var.environment_variables
    }
  }

  dynamic "dead_letter_config" {
    for_each = var.dead_letter_target_arn == null ? [] : [true]
    content {
      target_arn = var.dead_letter_target_arn
    }
  }

  dynamic "tracing_config" {
    for_each = var.tracing_mode == null ? [] : [true]
    content {
      mode = var.tracing_mode
    }
  }

  dynamic "vpc_config" {
    for_each = var.vpc_subnet_ids != null && var.vpc_security_group_ids != null ? [true] : []
    content {
      security_group_ids = var.vpc_security_group_ids
      subnet_ids         = var.vpc_subnet_ids
    }
  }

  dynamic "file_system_config" {
    for_each = var.file_system_arn != null && var.file_system_local_mount_path != null ? [true] : []
    content {
      local_mount_path = var.file_system_local_mount_path
      arn              = var.file_system_arn
    }
  }

  tags = var.tags

  depends_on = [aws_cloudwatch_log_group.lambda]
}


data "aws_cloudwatch_log_group" "lambda" {
  count =  var.create_function  && var.use_existing_cloudwatch_log_group ? 1 : 0

  name = "/aws/lambda/${var.function_name}"
}

resource "aws_cloudwatch_log_group" "lambda" {
  count =  var.create_function  && !var.use_existing_cloudwatch_log_group ? 1 : 0

  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = var.cloudwatch_logs_retention_in_days
  kms_key_id        = var.cloudwatch_logs_kms_key_id

  tags = merge(var.tags, var.cloudwatch_logs_tags)
}

resource "aws_lambda_provisioned_concurrency_config" "current_version" {
  count =  var.create_function  && var.provisioned_concurrent_executions > -1 ? 1 : 0

  function_name = aws_lambda_function.this[0].function_name
  qualifier     = aws_lambda_function.this[0].version

  provisioned_concurrent_executions = var.provisioned_concurrent_executions
}



resource "aws_lambda_permission" "current_version_triggers" {
  for_each = { for k, v in var.allowed_triggers : k => v if var.create_function && var.create_current_version_allowed_triggers }

  function_name = aws_lambda_function.this[0].function_name
  qualifier     = aws_lambda_function.this[0].version

  statement_id       = try(each.value.statement_id, each.key)
  action             = try(each.value.action, "lambda:InvokeFunction")
  principal          = try(each.value.principal, format("%s.amazonaws.com", try(each.value.service, "")))
  source_arn         = try(each.value.source_arn, null)
  source_account     = try(each.value.source_account, null)
  event_source_token = try(each.value.event_source_token, null)
}

resource "aws_lambda_permission" "unqualified_alias_triggers" {
  for_each = { for k, v in var.allowed_triggers : k => v if var.create_function && var.create_unqualified_alias_allowed_triggers }

  function_name = aws_lambda_function.this[0].function_name

  statement_id       = try(each.value.statement_id, each.key)
  action             = try(each.value.action, "lambda:InvokeFunction")
  principal          = try(each.value.principal, format("%s.amazonaws.com", try(each.value.service, "")))
  source_arn         = try(each.value.source_arn, null)
  source_account     = try(each.value.source_account, null)
  event_source_token = try(each.value.event_source_token, null)
}

resource "aws_lambda_event_source_mapping" "this" {
  for_each = { for k, v in var.event_source_mapping : k => v if var.create_function }

  function_name = aws_lambda_function.this[0].arn

  event_source_arn = try(each.value.event_source_arn, null)

  batch_size                         = try(each.value.batch_size, null)
  maximum_batching_window_in_seconds = try(each.value.maximum_batching_window_in_seconds, null)
  enabled                            = try(each.value.enabled, null)
  starting_position                  = try(each.value.starting_position, null)
  starting_position_timestamp        = try(each.value.starting_position_timestamp, null)
  parallelization_factor             = try(each.value.parallelization_factor, null)
  maximum_retry_attempts             = try(each.value.maximum_retry_attempts, null)
  maximum_record_age_in_seconds      = try(each.value.maximum_record_age_in_seconds, null)
  bisect_batch_on_function_error     = try(each.value.bisect_batch_on_function_error, null)
  topics                             = try(each.value.topics, null)
  queues                             = try(each.value.queues, null)
  function_response_types            = try(each.value.function_response_types, null)

  dynamic "destination_config" {
    for_each = try(each.value.destination_arn_on_failure, null) != null ? [true] : []
    content {
      on_failure {
        destination_arn = each.value["destination_arn_on_failure"]
      }
    }
  }

  dynamic "self_managed_event_source" {
    for_each = try(each.value.self_managed_event_source, [])
    content {
      endpoints = self_managed_event_source.value.endpoints
    }
  }

  dynamic "source_access_configuration" {
    for_each = try(each.value.source_access_configuration, [])
    content {
      type = source_access_configuration.value["type"]
      uri  = source_access_configuration.value["uri"]
    }
  }

  dynamic "filter_criteria" {
    for_each = try(each.value.filter_criteria, null) != null ? [true] : []

    content {
      filter {
        pattern = try(each.value["filter_criteria"].pattern, null)
      }
    }
  }
}