resource "aws_iam_account_password_policy" "this" {
  allow_users_to_change_password = true
  hard_expiry                    = var.password_policy.hard_expiry
  max_password_age               = var.password_policy.max_password_age
  minimum_password_length        = var.password_policy.minimum_password_length
  password_reuse_prevention      = var.password_policy.password_reuse_prevention
  require_lowercase_characters   = true
  require_numbers                = true
  require_symbols                = true
  require_uppercase_characters   = true
}
