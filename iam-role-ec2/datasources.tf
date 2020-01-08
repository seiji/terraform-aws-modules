data aws_iam_policy ec2_for_ssm {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

data aws_iam_policy_document ec2_for_ssm {
  source_json = data.aws_iam_policy.ec2_for_ssm.policy
}

data aws_iam_policy cwa_server {
  arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

data aws_iam_policy_document cwa_server {
  source_json = data.aws_iam_policy.cwa_server.policy
}
