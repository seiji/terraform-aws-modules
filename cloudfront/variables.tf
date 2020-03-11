variable namespace {
  type = string
}

variable stage {
  type = string
}

variable attributes {
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

variable origin {
  type = object({
    domain_name = string
    origin_id   = string
    origin_path = string
    custom_origin_config = object({
      http_port  = number
      https_port = number
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
