data aws_acm_certificate this {
  domain      = "*.seiji.me"
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}

data aws_route53_zone this {
  name         = "seiji.me."
  private_zone = false
}

data aws_apigatewayv2_api this {
  api_id = "12e5y1mfi2"
}

module apigatewayv2_custom_domain {
  source      = "../../apigatewayv2/custom-domain"
  namespace   = local.namespace
  stage       = local.stage
  domain_name = "api.seiji.me"
  domain_name_configuration = {
    certificate_arn = data.aws_acm_certificate.this.arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }
  api_mapping = [
    {
      api_id          = "12e5y1mfi2"
      stage           = "$default"
      api_mapping_key = null
    },
  ]
}

module route53_record {
  source  = "../../route53-record"
  name    = "api.seiji.me"
  zone_id = data.aws_route53_zone.this.zone_id
  alias = {
    name    = module.apigatewayv2_custom_domain.target_domain_name
    zone_id = module.apigatewayv2_custom_domain.hosted_zone_id
  }
}

output out {
  value = data.aws_apigatewayv2_api.this
}
