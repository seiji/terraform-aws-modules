module iam_policy_custom {
  source = "../../iam-policy-custom"
}

locals {
  human_group_policies = [
    "arn:aws:iam::aws:policy/IAMUserChangePassword",
    "arn:aws:iam::aws:policy/IAMUserSSHKeys",
    module.iam_policy_custom.allow_access_key.arn,
    module.iam_policy_custom.enforce_mfa_device.arn,
  ]
}

module group_admin {
  source = "../../iam-group"
  name   = "admin"
  policies = concat(
    local.human_group_policies,
    [
      "arn:aws:iam::aws:policy/job-function/SupportUser",
      "arn:aws:iam::aws:policy/job-function/ViewOnlyAccess",
      "arn:aws:iam::aws:policy/IAMAccessAnalyzerReadOnlyAccess",
    ],
  )
}

module group_developers {
  source = "../../iam-group"
  name   = "developers"
  policies = concat(
    local.human_group_policies,
    [],
  )
}

module group_services {
  source   = "../../iam-group"
  name     = "services"
  policies = []
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
    {
      name   = "github"
      groups = [module.group_services.name]
    },
  ]
}

