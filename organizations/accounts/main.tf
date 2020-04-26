resource aws_organizations_account this {
  for_each = var.emails
  name     = each.key
  email    = each.value
}
