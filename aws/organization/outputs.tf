output "organization_id" {
  value = aws_organizations_organization.this.id
}

output "account_ids" {
  value = aws_organizations_organization.this.accounts.*.id
}

output "accounts" {
  value = { for k, v in aws_organizations_account.this :
    k => {
      id = v.id
    }
  }
}
