output "user_arns" {
  value = { for n, v in aws_iam_user.this :
    n => v.arn
  }
}
