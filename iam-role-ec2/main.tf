module label {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=master"
  namespace  = var.namespace
  stage      = var.stage
  attributes = ["ec2"]
}

module iam_role_ec2 {
  source     = "../iam-role"
  name       = module.label.id
  identifier = "ec2.amazonaws.com"
  policies = [
    data.aws_iam_policy_document.ec2_for_ssm.json,
    data.aws_iam_policy_document.cwa_server.json,
  ]
}

resource aws_iam_instance_profile this {
  name = module.label.id
  role = module.iam_role_ec2.role.id
}
