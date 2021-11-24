data "aws_iam_policy_document" "allow_ssm_session" {
  statement {
    effect = "Allow"
    actions = [
      "ssm:StartSession",
    ]
    resources = [
      "arn:aws:ec2:*:*:instance/*",
      "arn:aws:ssm:*:*:document/AWS-StartSSHSession",
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "ssm:TerminateSession"
    ]
    resources = [
      "arn:aws:ssm:*:*:session/&{aws:username}-*",
    ]
  }
}

resource "aws_iam_policy" "allow_ssm_session" {
  name   = "allow-ssm-session"
  path   = "/"
  policy = data.aws_iam_policy_document.allow_ssm_session.json
}
