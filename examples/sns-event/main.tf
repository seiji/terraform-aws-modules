terraform {
  required_version = "~> 0.12.0"
  backend "s3" {
    bucket         = "terraform-aws-modules-tfstate"
    region         = "ap-northeast-1"
    key            = "health.sns.examples"
    encrypt        = true
    dynamodb_table = "terraform-aws-modules-tfstate-lock"
  }
}

provider "aws" {
  version = "~> 2.36"
  region  = local.region
}

locals {
  region    = "ap-northeast-1"
  namespace = "sns-health"
  stage     = "staging"
}

module "sns_event_health" {
  source = "../../sns-event"
  name   = "event-health"
}

module "cloudwatch_event_rule_health" {
  source               = "../../cloudwatch-event-rule"
  target_sns_topic_arn = module.sns_event_health.arn
  enable_health        = true
}

module "sns_event_ssm" {
  source = "../../sns-event"
  name   = "event-ssm"
}

module "cloudwatch_event_rule_ssm" {
  source               = "../../cloudwatch-event-rule"
  target_sns_topic_arn = module.sns_event_ssm.arn
  enable_ssm = true
}
