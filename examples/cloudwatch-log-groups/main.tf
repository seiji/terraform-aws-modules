terraform {
  required_version = "~> 0.12.0"
  backend "s3" {
    bucket         = "terraform-aws-modules-tfstate"
    region         = "ap-northeast-1"
    key            = "log-groups.cloudwatch.examples"
    encrypt        = true
    dynamodb_table = "terraform-aws-modules-tfstate-lock"
  }
}

provider aws {
  version = "~> 2.36"
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
