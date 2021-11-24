module "label" {
  source     = "../label"
  namespace  = var.namespace
  stage      = var.stage
  attributes = ["rds"]
}

module "iam_role" {
  source = "../iam-role"
  name   = module.label.id
  principals = {
    type        = "Service"
    identifiers = ["export.rds.amazonaws.com"]
  }
  policy_json_list = concat([data.aws_iam_policy_document.rds.json], var.policies)
}
