terraform {
  required_version = "~> 0.12.0"
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

module iam_groups {
  source = "../../iam-group"
  groups = {
    "Developers" : {
      path     = "/users/"
      policies = [module.iam_policies.allow_change_password.arn]
    }
  }
}

