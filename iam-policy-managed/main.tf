locals {
  account_id = data.aws_caller_identity.current.account_id
}

data aws_caller_identity current {}

data aws_iam_policy administrator_access {
  arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

data aws_iam_policy billing {
  arn = "arn:aws:iam::aws:policy/job-function/Billing"
}

data aws_iam_policy database_administrator {
  arn = "arn:aws:iam::aws:policy/job-function/DatabaseAdministrator"
}

data aws_iam_policy data_scientist {
  arn = "arn:aws:iam::aws:policy/job-function/DataScientist"
}

data aws_iam_policy network_administrator {
  arn = "arn:aws:iam::aws:policy/job-function/NetworkAdministrator"
}

data aws_iam_policy power_user_access {
  arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}

data aws_iam_policy security_audit {
  arn = "arn:aws:iam::aws:policy/SecurityAudit"
}

data aws_iam_policy support_user {
  arn = "arn:aws:iam::aws:policy/job-function/SupportUser"
}

data aws_iam_policy system_administrator {
  arn = "arn:aws:iam::aws:policy/job-function/SystemAdministrator"
}

data aws_iam_policy view_only_access {
  arn = "arn:aws:iam::aws:policy/job-function/ViewOnlyAccess"
}
