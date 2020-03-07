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

module iam_policy_custom {
  source = "../../iam-policy-custom"
}

data aws_iam_policy iam_user_change_password {
  arn = "arn:aws:iam::aws:policy/IAMUserChangePassword"
}

data aws_iam_policy iam_user_ssh_keys {
  arn = "arn:aws:iam::aws:policy/IAMUserSSHKeys"
}

locals {
  default_group_policies = [
    data.aws_iam_policy.iam_user_change_password.arn,
    data.aws_iam_policy.iam_user_ssh_keys.arn,
    module.iam_policy_custom.allow_access_key.arn,
    module.iam_policy_custom.enforce_mfa_device.arn,
    module.iam_policy_custom.allow_sts_assume.arn,
  ]
}

data aws_iam_policy support_user {
  arn = "arn:aws:iam::aws:policy/job-function/SupportUser"
}

data aws_iam_policy view_only_access {
  arn = "arn:aws:iam::aws:policy/job-function/ViewOnlyAccess"
}

data aws_iam_policy iam_access_analyzer_ro {
  arn = "arn:aws:iam::aws:policy/IAMAccessAnalyzerReadOnlyAccess"
}

module group_admin {
  source = "../../iam-group"
  name   = "admin"
  policies = concat(
    local.default_group_policies,
    [
      data.aws_iam_policy.support_user.arn,
      data.aws_iam_policy.view_only_access.arn,
      data.aws_iam_policy.iam_access_analyzer_ro.arn,
    ],
  )
}

module group_developers {
  source = "../../iam-group"
  name   = "developers"
  policies = concat(
    local.default_group_policies,
    [],
  )
}

module users {
  source = "../../iam-users"
  users = [
    {
      name   = "seiji"
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
    type = "AWS"
    identifiers = [
      module.users.users["seiji"].arn,
    ]
  }
}

data aws_iam_policy iam_ro {
  arn = "arn:aws:iam::aws:policy/IAMReadOnlyAccess"
}

data aws_iam_policy resource_group_ro {
  arn = "arn:aws:iam::aws:policy/AWSResourceGroupsReadOnlyAccess"
}

data aws_iam_policy ssm_ro {
  arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
}

module assume_ssm_role {
  source = "../../iam-role"
  name   = "assume-ssm-role"
  policy_arns = [
    data.aws_iam_policy.iam_ro.arn,
    data.aws_iam_policy.resource_group_ro.arn,
    data.aws_iam_policy.ssm_ro.arn,
    module.iam_policy_custom.allow_ssm_session.arn,
  ]
  principals = {
    type = "AWS"
    identifiers = [
      module.users.users["seiji"].arn,
    ]
  }
}

