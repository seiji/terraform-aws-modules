module "iam_role_es_cognito_access" {
  source = "../iam-role"
  name   = var.name
  principals = {
    type        = "Service"
    identifiers = ["es.amazonaws.com"]
  }
  policy_json_list = [
    data.aws_iam_policy_document.es_cognito_access.json,
  ]
}
