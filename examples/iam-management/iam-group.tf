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

module iam_groups {
  source = "../../iam/groups"
  groups = {
    admin = concat(
      local.human_group_policies,
      [
        "arn:aws:iam::aws:policy/job-function/SupportUser",
        "arn:aws:iam::aws:policy/job-function/ViewOnlyAccess",
        "arn:aws:iam::aws:policy/IAMAccessAnalyzerReadOnlyAccess",
      ],
    )
    developers = concat(
      local.human_group_policies,
      [],
    )
    services = []
  }
  users = {
    seiji  = ["admin"]
    guest1 = ["developers"]
    guest2 = ["developers"]
    guest3 = ["developers"]
    github = ["services"]
  }
}
