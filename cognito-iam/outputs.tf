output "user_pool" {
  value = aws_cognito_user_pool.this
}

output "identity_pool" {
  value = aws_cognito_identity_pool.this
}

output "iam_role_auth" {
  value = aws_iam_role.auth
}

output "iam_role_unauth" {
  value = aws_iam_role.unauth
}

