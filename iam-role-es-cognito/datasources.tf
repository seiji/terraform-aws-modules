data aws_iam_policy es_cognito_access {
  arn = "arn:aws:iam::aws:policy/AmazonESCognitoAccess"
}

data aws_iam_policy_document es_cognito_access {
  source_json = data.aws_iam_policy.es_cognito_access.policy
}
