output arns {
  value = { for name, value in aws_ecr_repository.this : name => value.arn }
}

output repository_urls {
  value = { for name, value in aws_ecr_repository.this : name => value.repository_url }
}
