terraform {
  required_version = "~> 0.12.0"
  backend "s3" {
    bucket         = "terraform-aws-modules-tfstate"
    region         = "ap-northeast-1"
    encrypt        = true
    key            = "iam-management.examples"
    dynamodb_table = "terraform-aws-modules-tfstate-lock"
  }
}

provider "aws" {
  version = "~> 2.36"
  region  = local.region
}

locals {
  region    = "ap-northeast-1"
  namespace = "iam-policies"
  stage     = "staging"
}

module iam_policies {
  source = "../../iam-policy-custom"
}

module iam_users {
  source = "../../iam-users"
  users = {
    guest1 : {
      path = "/users/"
    }
    guest2 : {
      path = "/users/"
    }
    guest3 : {
      path = "/users/"
    }
  }
}

module group_developers {
  source = "../../iam-group"
  name   = "Developers"
  path   = "/users/"
  policies = [
    module.iam_policies.allow_access_key.arn,
    module.iam_policies.allow_change_password.arn,
    module.iam_policies.allow_mfa_device.arn,
  ]
  users = [for k, v in module.iam_users.users : v.name]
}
