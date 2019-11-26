terraform {
  required_version = "~> 0.12.0"
  backend "s3" {
    bucket         = "terraform-aws-modules-tfstate"
    region         = "ap-northeast-1"
    key            = "ssm.examples"
    encrypt        = true
    dynamodb_table = "terraform-aws-modules-tfstate-lock"
  }
}

provider "aws" {
  version = "~> 2.39"
  region  = local.region
}

locals {
  region    = "ap-northeast-1"
  namespace = "sm" # not use /ssm/
  stage     = "staging"
}

module "ssm_parameters" {
  source = "../../ssm-parameters"

  namespace = local.namespace
  stage     = local.stage

  parameters = {
    "foo" = {
      type  = "String",
      value = "string"
    },
    "bar" = {
      type  = "SecureString",
      value = "secure"
    },
  }
}
