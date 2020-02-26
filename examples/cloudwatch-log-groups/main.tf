terraform {
  required_version = "~> 0.12.0"
}

provider aws {
  version = "~> 2.50"
  region  = local.region
}

locals {
  region    = "ap-northeast-1"
  namespace = "cloudwatch-log-groups"
  stage     = "staging"
}

module cloudwatch_log_group {
  source            = "../../cloudwatch-log-group"
  namespace         = local.namespace
  stage             = local.stage
  name              = "/examples/staging/cloudwatch-log-groups"
  retention_in_days = 7
}

module cloudwatch_log_metric_filter {
  source         = "../../cloudwatch-log-metric-filter"
  namespace      = local.namespace
  stage          = local.stage
  attributes     = ["test"]
  pattern        = <<PATTERN
    { $.responseElements.ConsoleLogin = "Failure" }
PATTERN
  log_group_name = module.cloudwatch_log_group.name
}

module cloudwatch_log_s3 {
  source    = "../../s3"
  namespace = local.namespace
  stage     = local.stage
}

module kinesis_firehose_s3 {
  source         = "../../kinesis-firehose-s3"
  namespace      = local.namespace
  stage          = local.stage
  bucket_arn     = module.cloudwatch_log_s3.arn
  log_group_name = module.cloudwatch_log_group.name
}

module cloudwatch_log_subscription_filter {
  source          = "../../cloudwatch-log-subscription-filter"
  namespace       = local.namespace
  stage           = local.stage
  destination_arn = module.kinesis_firehose_s3.arn
  log_group_name  = module.cloudwatch_log_group.name
}
