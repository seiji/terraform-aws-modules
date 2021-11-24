module "label" {
  source     = "../label"
  namespace  = var.namespace
  stage      = var.stage
  attributes = var.attributes
}

resource "aws_cloudfront_origin_access_identity" "this" {
  count   = var.origin.s3_origin ? 1 : 0
  comment = "access-identity-"
}

resource "aws_cloudfront_distribution" "this" {
  aliases             = var.aliases
  comment             = var.comment
  default_root_object = var.default_root_object
  enabled             = true
  is_ipv6_enabled     = true

  dynamic "custom_error_response" {
    for_each = var.custom_error_response
    content {
      error_caching_min_ttl = custom_error_response.value.error_caching_min_ttl
      error_code            = custom_error_response.value.error_code
      response_code         = custom_error_response.value.response_code
      response_page_path    = custom_error_response.value.response_page_path
    }
  }
  default_cache_behavior {
    allowed_methods  = var.default_cache_behavior.allowed_methods
    cached_methods   = var.default_cache_behavior.cached_methods
    target_origin_id = var.default_cache_behavior.target_origin_id

    forwarded_values {
      headers      = var.default_cache_behavior.forwarded_values.headers
      query_string = var.default_cache_behavior.forwarded_values.query_string
      cookies {
        forward = var.default_cache_behavior.forwarded_values.cookies.forward
      }
    }
    viewer_protocol_policy = "redirect-to-https"
  }
  dynamic "logging_config" {
    for_each = [for l in var.logging_config != null ? [var.logging_config] : [] : l]
    content {
      bucket = logging_config.value.bucket
      prefix = logging_config.value.prefix
    }
  }
  dynamic "origin" {
    for_each = [for o in var.origin != null ? [var.origin] : [] : o]
    content {
      domain_name = origin.value.domain_name
      origin_id   = origin.value.origin_id
      origin_path = origin.value.origin_path

      dynamic "custom_header" {
        for_each = [for c in origin.value.custom_header : c]
        content {
          name  = custom_header.value.name
          value = custom_header.value.value
        }
      }
      dynamic "custom_origin_config" {
        for_each = [for c in origin.value.s3_origin ? [] : [true] : c]
        content {
          http_port                = var.origin.custom_origin_config.http_port
          https_port               = var.origin.custom_origin_config.https_port
          origin_keepalive_timeout = var.origin.custom_origin_config.origin_keepalive_timeout
          origin_protocol_policy   = var.origin.custom_origin_config.origin_protocol_policy
          origin_read_timeout      = var.origin.custom_origin_config.origin_read_timeout
          origin_ssl_protocols     = var.origin.custom_origin_config.origin_ssl_protocols
        }
      }
      dynamic "s3_origin_config" {
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
