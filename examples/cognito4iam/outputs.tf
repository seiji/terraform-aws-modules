output "user_pool" {
  value = module.cognito.user_pool
}

output "identity_pool" {
  value = module.cognito.identity_pool
}

output "iam_role_auth" {
  value = module.cognito.iam_role_auth
}

output "iam_role_unauth" {
  value = module.cognito.iam_role_unauth
}
