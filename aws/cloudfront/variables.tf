variable service {
  type = string
}

variable env {
  type = string
}

variable name {
  type    = string
  default = ""
}

variable attributes {
  type    = list(string)
  default = []
}

variable aliases {
  type    = list(string)
  default = []
}

variable comment {
  type    = string
  default = null
}

variable default_root_object {
  type    = string
  default = null
}

variable custom_error_response {
  type = list(object({
    error_caching_min_ttl = number
    error_code            = number
    response_code         = number
    response_page_path    = string
  }))
  default = []
}

variable default_cache_behavior {
  type = object({
    allowed_methods  = list(string)
    cached_methods   = list(string)
    compress         = bool
    default_ttl      = number
    max_ttl          = number
    min_ttl          = number
    target_origin_id = string
    forwarded_values = object({
      headers      = list(string)
      query_string = bool
      cookies = object({
        forward = string
      })
    })
  })
}

variable ordered_cache_behaviors {
  type = list(object({
    allowed_methods  = list(string)
    cached_methods   = list(string)
    compress         = bool
    default_ttl      = number
    max_ttl          = number
    min_ttl          = number
    path_pattern     = string
    target_origin_id = string
    forwarded_values = object({
      headers      = list(string)
      query_string = bool
      cookies = object({
        forward = string
      })
    })
  }))
  default = []
}

variable logging_config {
  type = object({
    bucket = string
    prefix = string
  })
}

variable origin {
  type = object({
    domain_name = string
    origin_id   = string
    origin_path = string
    custom_header = list(object({
      name  = string
      value = string
    }))
    custom_origin_config = object({
      http_port                = number
      https_port               = number
      origin_keepalive_timeout = number
      origin_protocol_policy   = string
      origin_read_timeout      = number
      origin_ssl_protocols     = list(string)
    })
    s3_origin = bool
  })
}

variable viewer_certificate {
  type = object({
    acm_certificate_arn            = string
    cloudfront_default_certificate = bool
    minimum_protocol_version       = string
    ssl_support_method             = string
  })
}
