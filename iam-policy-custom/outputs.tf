output allow_access_key {
  value = aws_iam_policy.allow_access_key
}

output allow_mfa_device {
  value = aws_iam_policy.allow_mfa_device
}

output allow_ssm_session {
  value = aws_iam_policy.allow_ssm_session
}
