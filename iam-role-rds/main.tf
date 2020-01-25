module label {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=master"
  namespace  = var.namespace
  stage      = var.stage
  attributes = ["rds"]
}

module iam_role {
  source     = "../iam-role"
  name       = module.label.id
  identifier = "export.rds.amazonaws.com"
  policies   = concat([data.aws_iam_policy_document.rds.json], var.policies)
}
