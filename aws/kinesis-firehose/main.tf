module "label" {
  source     = "../../label"
  service    = var.service
  env        = var.env
  attributes = var.attributes
  name       = var.name
  add_tags   = var.add_tags
}

resource "aws_kinesis_firehose_delivery_stream" "this" {
  name        = module.label.id
  destination = var.destination
  dynamic "http_endpoint_configuration" {
    for_each = var.http_endpoint_configuration != null ? [var.http_endpoint_configuration] : []
    content {
      buffering_interval = http_endpoint_configuration.value.buffering_interval
      buffering_size     = http_endpoint_configuration.value.buffering_size
      name               = http_endpoint_configuration.value.name
      retry_duration     = http_endpoint_configuration.value.retry_duration
      role_arn           = http_endpoint_configuration.value.role_arn
      url                = http_endpoint_configuration.value.url
      dynamic "cloudwatch_logging_options" {
        for_each = http_endpoint_configuration.value.cloudwatch_logging_options != null ? [http_endpoint_configuration.value.cloudwatch_logging_options] : []
        content {
          enabled         = cloudwatch_logging_options.value.enabled
          log_group_name  = cloudwatch_logging_options.value.log_group_name
          log_stream_name = cloudwatch_logging_options.value.log_stream_name
        }
      }
    }
  }
  dynamic "s3_configuration" {
    for_each = var.s3_configuration != null ? [var.s3_configuration] : []
    content {
      bucket_arn         = s3_configuration.value.bucket_arn
      buffer_interval    = s3_configuration.value.buffer_interval
      buffer_size        = s3_configuration.value.buffer_size
      compression_format = s3_configuration.value.compression_format
      prefix             = s3_configuration.value.prefix
      role_arn           = s3_configuration.value.role_arn
      dynamic "cloudwatch_logging_options" {
        for_each = s3_configuration.value.cloudwatch_logging_options != null ? [s3_configuration.value.cloudwatch_logging_options] : []
        content {
          enabled         = cloudwatch_logging_options.value.enabled
          log_group_name  = cloudwatch_logging_options.value.log_group_name
          log_stream_name = cloudwatch_logging_options.value.log_stream_name
        }
      }
    }
  }
  dynamic "extended_s3_configuration" {
    for_each = var.extended_s3_configuration != null ? [var.extended_s3_configuration] : []
    content {
      bucket_arn          = extended_s3_configuration.value.bucket_arn
      buffer_interval     = extended_s3_configuration.value.buffer_interval
      buffer_size         = extended_s3_configuration.value.buffer_size
      compression_format  = extended_s3_configuration.value.compression_format
      error_output_prefix = extended_s3_configuration.value.error_output_prefix
      kms_key_arn         = extended_s3_configuration.value.kms_key_arn
      prefix              = extended_s3_configuration.value.prefix
      role_arn            = extended_s3_configuration.value.role_arn
      s3_backup_mode      = extended_s3_configuration.value.s3_backup_mode
      dynamic "cloudwatch_logging_options" {
        for_each = extended_s3_configuration.value.cloudwatch_logging_options != null ? [extended_s3_configuration.value.cloudwatch_logging_options] : []
        content {
          enabled         = cloudwatch_logging_options.value.enabled
          log_group_name  = cloudwatch_logging_options.value.log_group_name
          log_stream_name = cloudwatch_logging_options.value.log_stream_name
        }
      }
      dynamic "processing_configuration" {
        for_each = extended_s3_configuration.value.processing_configuration != null ? [extended_s3_configuration.value.processing_configuration] : []
        content {
          enabled = processing_configuration.value.enabled
          dynamic "processors" {
            for_each = processing_configuration.value.processors
            content {
              type = processors.value.type
              dynamic "parameters" {
                for_each = processors.value.parameters
                content {
                  parameter_name  = parameters.value.parameter_name
                  parameter_value = parameters.value.parameter_value
                }
              }
            }
          }
        }
      }
    }
  }
}
