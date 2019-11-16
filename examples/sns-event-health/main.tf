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
  source = "../../sns-event-health"
  name   = "event-health"
}

module "event_health" {
  source               = "../../event-health"
  target_sns_topic_arn = module.sns_event_health.arn
}
