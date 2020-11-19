output id {
  value = aws_cloudfront_distribution.this.id
}

output arn {
  value = aws_cloudfront_distribution.this.arn
}

output domain_name {
  value = aws_cloudfront_distribution.this.domain_name
}

output hosted_zone_id {
  value = aws_cloudfront_distribution.this.hosted_zone_id
}

output origin_access_identity_iam_arn {
  value = var.origin.s3_origin ? aws_cloudfront_origin_access_identity.this[0].iam_arn : null
}
