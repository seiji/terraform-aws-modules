data aws_iam_policy_document allow_ssm_session {
  statement {
    actions = [
      "ssm:StartSession",
    ]
    effect = "Allow"
    resources = [
      "arn:aws:ec2:*:*:instance/*",
      "arn:aws:ssm:*:*:document/AWS-StartSSHSession",
    ]
  }
  statement {
    actions = [
      "ec2:DescribeInstances",
    ]
    effect    = "Allow"
    resources = ["*"]
  }
}

resource aws_iam_policy allow_ssm_session {
  name   = "allow-ssm-session"
  path   = "/"
  policy = data.aws_iam_policy_document.allow_ssm_session.json
}
