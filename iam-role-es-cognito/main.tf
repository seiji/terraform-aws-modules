module iam_role_es_cognito_access {
  source     = "../iam-role"
  name       = var.name
  identifier = "es.amazonaws.com"
  policiy_json_list = [
    data.aws_iam_policy_document.es_cognito_access.json,
  ]
}
