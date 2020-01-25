output arn {
  value = aws_s3_bucket.this.arn
}

output "policy_document" {
  value = data.aws_iam_policy_document.this
}
