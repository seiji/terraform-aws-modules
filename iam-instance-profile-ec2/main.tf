module label {
  source    = "git::https://github.com/cloudposse/terraform-null-label.git?ref=master"
  namespace = var.namespace
  stage     = var.stage
  attributes = ["ec2"]
}

data aws_iam_policy_document ec2_cloudwatch {
  statement {
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource aws_iam_role ec2 {
  name               = module.label.id
  assume_role_policy = data.aws_iam_policy_document.ec2_cloudwatch.json
  tags = module.label.tags
}

resource aws_iam_role_policy_attachment ssm {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
  role       = aws_iam_role.ec2.id
}

resource aws_iam_role_policy_attachment cw_server {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  role       = aws_iam_role.ec2.id
}

resource aws_iam_instance_profile ec2 {
  name = module.label.id
  role = aws_iam_role.ec2.id
}
