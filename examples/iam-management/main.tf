terraform {
  required_version = ">= 0.12.0"
  backend "s3" {
    bucket         = "terraform-aws-modules-tfstate"
    region         = "ap-northeast-1"
    encrypt        = true
    key            = "iam-management.examples"
    dynamodb_table = "terraform-aws-modules-tfstate-lock"
  }
}

provider "aws" {
  version = ">= 2.50"
  region  = "ap-northeast-1"
}

module iam_policy_managed {
  source = "../../iam-policy-managed"
}

module iam_policy_custom {
  source = "../../iam-policy-custom"
}

module group_admin {
  source = "../../iam-group"
  name   = "admin"
  path   = "/users/"
  policies = [
    module.iam_policy_managed.administrator_access.arn
  ]
}

module group_developers {
  source = "../../iam-group"
  name   = "developers"
  path   = "/users/"
  policies = [
    module.iam_policy_custom.allow_access_key.arn,
    module.iam_policy_custom.allow_change_password.arn,
    module.iam_policy_custom.allow_mfa_device.arn,
  ]
}

module users {
  source = "../../iam-users"
  users = [
    {
      name   = "admin"
      path   = "/users/"
      groups = [module.group_admin.name]
    },
    {
      name   = "guest1"
      path   = "/users/"
      groups = [module.group_developers.name]
    },
    {
      name   = "guest2"
      path   = "/users/"
      groups = [module.group_developers.name]
    },
    {
      name   = "guest3"
      path   = "/users/"
      groups = [module.group_developers.name]
    },
  ]
}
