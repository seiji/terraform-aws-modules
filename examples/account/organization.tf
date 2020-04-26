output accounts {
  value = module.organization_accounts.ids

}
module organization {
  source = "../../organizations/organization"
  aws_service_access_principals = [
    "cloudtrail.amazonaws.com",
    # "config.amazonaws.com",
    "controltower.amazonaws.com",
    "sso.amazonaws.com",
  ]
  enabled_policy_types = [
    "SERVICE_CONTROL_POLICY",
  ]
}
