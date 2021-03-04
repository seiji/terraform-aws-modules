module "label" {
  source     = "../../label"
  service    = var.service
  env        = var.env
  name       = var.name
  attributes = var.attributes
}

resource "aws_cloudfront_origin_access_identity" "this" {
  count   = var.origin.s3_origin ? 1 : 0
  comment = "access-identity-${var.origin.domain_name}"
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
    compress         = var.default_cache_behavior.compress
    default_ttl      = var.default_cache_behavior.default_ttl
    max_ttl          = var.default_cache_behavior.max_ttl
    min_ttl          = var.default_cache_behavior.min_ttl
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
  dynamic "ordered_cache_behavior" {
    for_each = var.ordered_cache_behaviors != null ? var.ordered_cache_behaviors : []
    content {
      allowed_methods  = ordered_cache_behavior.value.allowed_methods
      cached_methods   = ordered_cache_behavior.value.cached_methods
      compress         = ordered_cache_behavior.value.compress
      default_ttl      = ordered_cache_behavior.value.default_ttl
      max_ttl          = ordered_cache_behavior.value.max_ttl
      min_ttl          = ordered_cache_behavior.value.min_ttl
      path_pattern     = ordered_cache_behavior.value.path_pattern
      target_origin_id = ordered_cache_behavior.value.target_origin_id
      forwarded_values {
        headers      = ordered_cache_behavior.value.forwarded_values.headers
        query_string = ordered_cache_behavior.value.forwarded_values.query_string
        cookies {
          forward = ordered_cache_behavior.value.forwarded_values.cookies.forward
        }
      }
      viewer_protocol_policy = "redirect-to-https"
    }
  }
  dynamic "logging_config" {
    for_each = var.logging_config != null ? [var.logging_config] : []
    content {
      bucket = logging_config.value.bucket
      prefix = logging_config.value.prefix
    }
  }
  dynamic "origin" {
    for_each = var.origin != null ? [var.origin] : []
    content {
      domain_name = origin.value.domain_name
      origin_id   = origin.value.origin_id
      origin_path = origin.value.origin_path

      dynamic "custom_header" {
        for_each = origin.value.custom_header != null ? [origin.value.custom_header] : []
        content {
          name  = custom_header.value.name
          value = custom_header.value.value
        }
      }
      dynamic "custom_origin_config" {
        for_each = origin.value.custom_origin_config != null ? [origin.value.custom_origin_config] : []
        content {
          http_port                = custom_origin_config.value.http_port
          https_port               = custom_origin_config.value.https_port
          origin_keepalive_timeout = custom_origin_config.value.origin_keepalive_timeout
          origin_protocol_policy   = custom_origin_config.value.origin_protocol_policy
          origin_read_timeout      = custom_origin_config.value.origin_read_timeout
          origin_ssl_protocols     = custom_origin_config.value.origin_ssl_protocols
        }
      }
      dynamic "s3_origin_config" {
        for_each = origin.value.s3_origin ? [true] : []
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

  tags = module.label.tags
  depends_on = [
    aws_cloudfront_origin_access_identity.this[0],
  ]
}
