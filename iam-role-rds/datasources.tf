data "aws_iam_policy" "rds" {
  arn = "arn:aws:iam::aws:policy/aws-service-role/AmazonRDSServiceRolePolicy"
}

data "aws_iam_policy_document" "rds" {
  source_json = data.aws_iam_policy.rds.policy
}
