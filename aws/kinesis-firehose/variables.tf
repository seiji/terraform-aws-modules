variable "service" {
  type = string
}

variable "env" {
  type = string
}

variable "attributes" {
  type    = list(string)
  default = []
}

variable "name" {
  type    = string
  default = ""
}

variable "add_tags" {
  type    = map(string)
  default = {}
}

variable "destination" {
  type    = string
  default = "extended_s3"
}

variable "http_endpoint_configuration" {
  type = object({
    buffering_interval = number
    buffering_size     = number
    name               = string
    retry_duration     = number
    role_arn           = string
    s3_backup_mode     = string
    url                = string
    processing_configuration = object({
      enabled = bool
    })
    request_configuration = object({
      content_encoding = string
    })
    cloudwatch_logging_options = object({
      enabled         = bool
      log_group_name  = string
      log_stream_name = string
    })
  })
  default = null
}

variable "s3_configuration" {
  type = object({
    bucket_arn         = string
    buffer_size        = number
    buffer_interval    = number
    compression_format = string
    prefix             = string
    role_arn           = string
    cloudwatch_logging_options = object({
      enabled         = bool
      log_group_name  = string
      log_stream_name = string
    })
  })
  default = null
}

variable "extended_s3_configuration" {
  type = object({
    bucket_arn          = string
    buffer_interval     = number
    buffer_size         = number
    compression_format  = string
    error_output_prefix = string
    kms_key_arn         = string
    prefix              = string
    role_arn            = string
    s3_backup_mode      = string
    cloudwatch_logging_options = object({
      enabled         = bool
      log_group_name  = string
      log_stream_name = string
    })
    processing_configuration = object({
      enabled = bool
      processors = list(object({
        type = string
        parameters = list(object({
          parameter_name  = string
          parameter_value = string
        }))
      }))
    })
  })
  default = null
}
