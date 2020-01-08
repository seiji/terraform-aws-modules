terraform {
  required_version = "~> 0.12.0"
  backend "s3" {
    bucket         = "terraform-aws-modules-tfstate"
    region         = "ap-northeast-1"
    encrypt        = true
    key            = "cognito-iam.examples"
    dynamodb_table = "terraform-aws-modules-tfstate-lock"
  }
}

provider "aws" {
  version = "~> 2.40"
  region  = "ap-northeast-1"
}

locals {
  name = "auth2iam"
}

data aws_caller_identity this {}

module cognito {
  source           = "../../cognito"
  name             = local.name
  user_pool_domain = "${local.name}-${data.aws_caller_identity.this.account_id}"
}

