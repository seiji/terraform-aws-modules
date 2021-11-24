terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  version = "~> 2.50"
  region  = "ap-northeast-1"
}

data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "terraform-aws-modules-tfstate"
    region = "ap-northeast-1"
    key    = "vpc-nati.examples"
  }
}

locals {
  namespace = "rds-aurora-mysql-snapshot"
  stage     = "staging"
  vpc = {
    id                        = data.terraform_remote_state.vpc.outputs.id
    default_security_group_id = data.terraform_remote_state.vpc.outputs.default_security_group_id
    private_subnet_ids        = data.terraform_remote_state.vpc.outputs.private_subnet_ids
    public_subnet_ids         = data.terraform_remote_state.vpc.outputs.public_subnet_ids
  }
}

module "sg_mysql" {
  source      = "../../vpc-sg-mysql"
  namespace   = local.namespace
  stage       = local.stage
  vpc_id      = local.vpc.id
  cidr_blocks = ["0.0.0.0/0"]
}

module "rds" {
  source                 = "../../rds-aurora-mysql"
  namespace              = local.namespace
  stage                  = local.stage
  subnet_ids             = local.vpc.public_subnet_ids
  database_name          = "test"
  instance_class         = "db.t3.small"
  instance_count         = 1
  master_username        = "username"
  vpc_security_group_ids = [local.vpc.default_security_group_id, module.sg_mysql.id]
  publicly_accessible    = true
}

module "export_s3" {
  source    = "../../s3"
  namespace = local.namespace
  stage     = local.stage
}

data "aws_iam_policy_document" "export_s3" {
  statement {
    actions = [
      "s3:DeleteObject",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:PutObject",
    ]
    resources = [
      module.export_s3.arn,
      "${module.export_s3.arn}/*",
    ]
  }
}

module "iam_role_export" {
  source    = "../../iam-role-rds"
  namespace = local.namespace
  stage     = local.stage
  policies  = [data.aws_iam_policy_document.export_s3.json]
}

module "export_kms" {
  source    = "../../kms"
  namespace = local.namespace
  stage     = local.stage
  role_arn  = module.iam_role_export.arn
}
