module label {
  source     = "../label"
  namespace  = var.namespace
  stage      = var.stage
  name       = var.name
  attributes = var.attributes
}

resource aws_cloudtrail this {
  name                          = module.label.id
  cloud_watch_logs_group_arn    = var.cloudwatch_log_group_arn
  cloud_watch_logs_role_arn     = var.cloudwatch_logs_role_arn
  enable_log_file_validation    = true
  enable_logging                = true
  include_global_service_events = true
  is_multi_region_trail         = true
  is_organization_trail         = var.is_organization_trail
  s3_bucket_name                = var.s3_bucket_name
  kms_key_id                    = var.kms_key_id

  event_selector {
    include_management_events = true
    read_write_type           = "All"

    data_resource {
      type   = "AWS::S3::Object"
      values = var.logging_s3_bucket_arns
    }
    data_resource {
      type   = "AWS::Lambda::Function"
      values = var.logging_lambda_function_arns
    }
  }

  tags = module.label.tags
}
