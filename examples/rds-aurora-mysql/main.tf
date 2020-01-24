terraform {
  required_version = ">= 0.12"
  backend "s3" {
    bucket         = "terraform-aws-modules-tfstate"
    region         = "ap-northeast-1"
    key            = "aurora.examples"
    encrypt        = true
    dynamodb_table = "terraform-aws-modules-tfstate-lock"
  }
}

provider "aws" {
  version = "~> 2.0"
  region  = "ap-northeast-1"
}

data terraform_remote_state vpc {
  backend = "s3"

  config = {
    bucket = "terraform-aws-modules-tfstate"
    region = "ap-northeast-1"
    key    = "vpc-nati.examples"
  }
}

locals {
  namespace = "rds-aurora-mysql"
  stage     = "staging"
  vpc = {
    id                        = data.terraform_remote_state.vpc.outputs.id
    default_security_group_id = data.terraform_remote_state.vpc.outputs.default_security_group_id
    private_subnet_ids        = data.terraform_remote_state.vpc.outputs.private_subnet_ids
    public_subnet_ids         = data.terraform_remote_state.vpc.outputs.public_subnet_ids
  }
}

# module "sns_topic" {
#   source    = "../../sns-alarm"
#   name      = "rds-alarts"
# }

resource "aws_db_subnet_group" "this" {
  name       = "rds-alerts"
  subnet_ids = local.vpc.private_subnet_ids
}

module "rds" {
  source            = "../../rds-aurora-mysql"
  namespace         = local.namespace
  stage             = local.stage
  name              = "sample"
  subnet_group_name = aws_db_subnet_group.this.name
  database_name     = "test"
  master_username   = "username"
  master_password   = "password"
}

# module "cloudwatch-alarms-rds" {
#   source          = "../../cloudwatch-alarms-rds"
#   namespace       = local.namespace
#   stage           = local.stage
#   db_instance_ids = module.rds.instance_ids
#   sns_topic_arn   = module.sns_topic.arn
# }
#
