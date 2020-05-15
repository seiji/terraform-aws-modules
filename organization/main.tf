locals {
  scp_full_aws_access_id = "p-FullAWSAccess"
}

resource aws_organizations_organization this {
  aws_service_access_principals = var.aws_service_access_principals
  enabled_policy_types          = var.enabled_policy_types
  feature_set                   = var.feature_set
}

resource aws_organizations_account this {
  for_each   = var.accounts
  name       = each.key
  email      = each.value.email
  parent_id  = each.value.parent_unit_name != null ? aws_organizations_organizational_unit.this[each.value.parent_unit_name].id : null
  depends_on = [aws_organizations_organizational_unit.this]
}

resource aws_organizations_policy scp {
  for_each    = var.service_control_policies
  name        = each.key
  description = each.value.description
  type        = "SERVICE_CONTROL_POLICY"
  content     = each.value.content
}

resource aws_organizations_organizational_unit this {
  for_each   = var.root_units
  name       = each.key
  parent_id  = aws_organizations_organization.this.roots.0.id
  depends_on = [aws_organizations_organization.this]
}

resource aws_organizations_policy_attachment unit {
  for_each = { for item in flatten([
    for n, policies in var.root_units : [
      for p in policies : {
        "${n}-${p}" = {
          target = n
          policy = p
        }
      }
    ]
    ]) :
    keys(item)[0] => values(item)[0]
  }
  policy_id = aws_organizations_policy.scp[each.value.policy].id
  target_id = aws_organizations_organizational_unit.this[each.value.target].id
  depends_on = [
    aws_organizations_policy.scp,
    aws_organizations_organizational_unit.this,
  ]
}
