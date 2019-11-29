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
  version = "~> 2.36"
  region  = local.region
}

locals {
  region    = "ap-northeast-1"
  namespace = "default"
  stage     = ""
}

module "cloud_trails" {
  source                 = "../../cloud-trails"
  namespace              = local.namespace
  stage                  = ""
  bucket_name            = "trail.seiji.me"
  logging_s3_bucket_arns = ["arn:aws:s3:::terraform-aws-modules-tfstate/"]
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
  enable_guard_duty    = true
}
