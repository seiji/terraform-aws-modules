terraform {
  required_version = "~> 0.12.0"
  backend "s3" {
    bucket         = "terraform-aws-modules-tfstate"
    region         = "ap-northeast-1"
    key            = "budget.sns.examples"
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
