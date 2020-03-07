output allow_access_key {
  value = aws_iam_policy.allow_access_key
}

output enforce_mfa_device {
  value = aws_iam_policy.enforce_mfa_device
}

output allow_sts_assume {
  value = aws_iam_policy.allow_sts_assume
}

output allow_ssm_session {
  value = aws_iam_policy.allow_ssm_session
}
