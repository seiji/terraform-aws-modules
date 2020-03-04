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

data aws_iam_policy iam_user_change_password {
  arn = "arn:aws:iam::aws:policy/IAMUserChangePassword"
}

module group_admin {
  source = "../../iam-group"
  name   = "admin"
  policies = [
    data.aws_iam_policy.iam_user_change_password.arn,
    module.iam_policy_custom.allow_access_key.arn,
    module.iam_policy_custom.allow_ssm_session.arn,
    module.iam_policy_custom.enforce_mfa_device.arn,
  ]
}

module group_developers {
  source = "../../iam-group"
  name   = "developers"
  policies = [
    data.aws_iam_policy.iam_user_change_password.arn,
    module.iam_policy_custom.allow_access_key.arn,
    module.iam_policy_custom.enforce_mfa_device.arn,
  ]
}

module users {
  source = "../../iam-users"
  users = [
    {
      name   = "admin"
      groups = [module.group_admin.name]
    },
    {
      name   = "guest1"
      groups = [module.group_developers.name]
    },
    {
      name   = "guest2"
      groups = [module.group_developers.name]
    },
    {
      name   = "guest3"
      groups = [module.group_developers.name]
    },
  ]
}

data aws_iam_policy administrator_access {
  arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

module assume_admin_role {
  source = "../../iam-role"
  name   = "assume-admin-role"
  policy_arns = [
    data.aws_iam_policy.administrator_access.arn,
  ]
  principals = {
    type        = "AWS"
    identifiers = [module.users.users["admin"].arn]
  }
}
