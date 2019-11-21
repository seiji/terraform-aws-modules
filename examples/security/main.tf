terraform {
  required_version = "~> 0.12.0"
  backend "s3" {
    bucket         = "terraform-aws-modules-tfstate"
    region         = "ap-northeast-1"
    key            = "security-hub.examples"
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
  namespace = "security-hub"
  stage     = "staging"
}

module "security_hub" {
  source = "../../security-hub"
}

module "guard_duty" {
  source = "../../guard-duty"
}

module "sns_event_guard_duty" {
  source = "../../sns-event"
  name   = "event-guard-duty"
}

module "cloudwatch_event_rule_ssm" {
  source               = "../../cloudwatch-event-rule"
  target_sns_topic_arn = module.sns_event_guard_duty.arn
  enable_guard_duty = true
}
