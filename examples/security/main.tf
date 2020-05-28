terraform {
  required_version = "~> 0.12.0"
  backend "s3" {
    bucket         = "terraform-aws-modules-tfstate"
    key            = "security-hub.examples"
    region         = "ap-northeast-1"
    encrypt        = true
    dynamodb_table = "terraform-aws-modules-tfstate-lock"
  }
}

provider "aws" {
  version = "~> 2.62"
  region  = "ap-northeast-1"
}

locals {
  namespace = "default"
  stage     = ""
}

module "cloudtrail" {
  source         = "../../cloudtrail"
  namespace      = local.namespace
  stage          = local.stage
  kms_key_id     = null
  s3_bucket_name = "trail.seiji.me"
}

# module "guard_duty" {
#   source = "../../guard-duty"
# }
#
module "sns_event_guard_duty" {
  source = "../../sns-event"
  name   = "event-guard-duty"
}

module "cloudwatch_event_rule_ssm" {
  source               = "../../cloudwatch-event-rule"
  target_sns_topic_arn = module.sns_event_guard_duty.arn
  enable_guard_duty    = true
}
