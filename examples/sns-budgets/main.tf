terraform {
  required_version = "~> 0.12.0"
}

provider "aws" {
  version = "~> 2.36"
  region  = local.region
}

locals {
  region    = "ap-northeast-1"
  namespace = "sns-budgets"
  stage     = "staging"
}

module "sns_budgets" {
  source = "../../sns-budgets"
  name   = "budgets"
}

module "budgets_cost" {
  source                    = "../../budgets-cost"
  subscriber_sns_topic_arns = [module.sns_budgets.arn]
}

module "budgets_savings_plans" {
  source                    = "../../budgets-savings-plans"
  subscriber_sns_topic_arns = [module.sns_budgets.arn]
}

module "budgets_usage" {
  source                    = "../../budgets-usage"
  subscriber_sns_topic_arns = [module.sns_budgets.arn]
}
