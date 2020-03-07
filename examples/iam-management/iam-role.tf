module assume_admin_role {
  source = "../../iam-role"
  name   = "assume-admin-role"
  policy_arns = [
    "arn:aws:iam::aws:policy/AdministratorAccess",
  ]
  principals = {
    type = "AWS"
    identifiers = [
      module.users.users["seiji"].arn,
    ]
  }
}

module assume_power_role {
  source = "../../iam-role"
  name   = "assume-power-role"
  policy_arns = [
    "arn:aws:iam::aws:policy/PowerUserAccess",
  ]
  principals = {
    type = "AWS"
    identifiers = [
      module.users.users["github"].arn,
    ]
  }
}

module assume_ssm_role {
  source = "../../iam-role"
  name   = "assume-ssm-role"
  policy_arns = [
    "arn:aws:iam::aws:policy/IAMReadOnlyAccess",
    "arn:aws:iam::aws:policy/AWSResourceGroupsReadOnlyAccess",
    "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess",
    module.iam_policy_custom.allow_ssm_session.arn,
  ]
  principals = {
    type = "AWS"
    identifiers = [
      module.users.users["seiji"].arn,
    ]
  }
}

