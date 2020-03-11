module label {
  source     = "../label"
  namespace  = var.namespace
  stage      = var.stage
  attributes = var.attributes
}

resource aws_cloudfront_origin_access_identity this {
  count   = var.origin.s3_origin ? 1 : 0
  comment = "access-identity-"
}

resource aws_cloudfront_distribution this {
  aliases             = var.aliases
  comment             = var.comment
  default_root_object = var.default_root_object
  enabled             = true
  is_ipv6_enabled     = true

  dynamic custom_error_response {
    for_each = var.custom_error_response
    content {
      error_caching_min_ttl = custom_error_response.value.error_caching_min_ttl
      error_code            = custom_error_response.value.error_code
      response_code         = custom_error_response.value.response_code
      response_page_path    = custom_error_response.value.response_page_path
    }
  }
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.origin.origin_id

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
    viewer_protocol_policy = "redirect-to-https"
  }
  dynamic origin {
    for_each = [for o in var.origin != null ? [var.origin] : [] : o]
    content {
      domain_name = origin.value.domain_name
      origin_id   = origin.value.origin_id
      origin_path = origin.value.origin_path

      dynamic s3_origin_config {
        for_each = [for c in origin.value.s3_origin ? [true] : [] : c]
        content {
          origin_access_identity = aws_cloudfront_origin_access_identity.this[0].cloudfront_access_identity_path
        }
      }
    }
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  viewer_certificate {
    acm_certificate_arn            = var.viewer_certificate.acm_certificate_arn
    cloudfront_default_certificate = var.viewer_certificate.cloudfront_default_certificate
    minimum_protocol_version       = var.viewer_certificate.minimum_protocol_version
    ssl_support_method             = var.viewer_certificate.ssl_support_method
  }

  depends_on = [
    aws_cloudfront_origin_access_identity.this[0],
  ]
}
