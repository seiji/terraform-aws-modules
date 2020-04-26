output ids {
  value = {
    for name, email in var.emails:
    name => aws_organizations_account.this[name].id
  }
}
