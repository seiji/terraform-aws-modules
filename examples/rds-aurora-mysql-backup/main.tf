terraform {
  required_version = ">= 0.12"
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
  namespace = "rds-aurora-mysql-backup"
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

module "rds" {
  source          = "../../rds-aurora-mysql"
  namespace       = local.namespace
  stage           = local.stage
  subnet_ids      = local.vpc.private_subnet_ids
  database_name   = "test"
  instance_class  = "db.t3.small"
  instance_count  = 1
  master_username = "username"
  master_password = "password"
}

# module "cloudwatch-alarms-rds" {
#   source          = "../../cloudwatch-alarms-rds"
#   namespace       = local.namespace
#   stage           = local.stage
#   db_instance_ids = module.rds.instance_ids
#   sns_topic_arn   = module.sns_topic.arn
# }
#
