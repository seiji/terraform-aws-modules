terraform {
  required_version = "~> 0.12.0"
  backend "s3" {
    bucket         = "terraform-aws-modules-tfstate"
    region         = "ap-northeast-1"
    key            = "aurora.examples"
    encrypt        = true
    dynamodb_table = "terraform-aws-modules-tfstate-lock"
  }
}

provider "aws" {
  version = "~> 2.22"
  region  = local.region
}

locals {
  region    = "ap-northeast-1"
  namespace = "aurora"
  stage     = "staging"
}

module "vpc" {
  source          = "../../vpc"
  region          = local.region
  namespace       = local.namespace
  stage           = local.stage
  cidr_block      = "10.0.0.0/16"
  azs             = ["ap-northeast-1a", "ap-northeast-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]
  use_natgw       = false
}

module "sns_topic" {
  source    = "../../sns"
  region    = local.region
  namespace = local.namespace
  stage     = local.stage
  name      = "rds-alarts"
}

resource "aws_db_subnet_group" "this" {
  name       = "rds-alerts"
  subnet_ids = module.vpc.private_subnet_id_list
}

module "rds" {
  source            = "../../rds-aurora-mysql"
  region            = local.region
  namespace         = local.namespace
  stage             = local.stage
  name              = "sample"
  subnet_group_name = aws_db_subnet_group.this.name
  database_name     = "test"
  master_username   = "username"
  master_password   = "password"
}

# module "rds-cloudwatch" {
#   source          = "../../rds-cloudwatch-alarms"
#   region          = local.region
#   namespace       = local.namespace
#   stage           = local.stage
#   sns_topic_arn = module.sns_topic.arn
# }
#
