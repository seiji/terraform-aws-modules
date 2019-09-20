output "bucket" {
  value = aws_s3_bucket.this.bucket
}

output "dynamodb_table" {
  value = aws_dynamodb_table.this.name
}
