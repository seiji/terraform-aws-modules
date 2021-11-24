module "label" {
  source     = "../../label"
  namespace  = var.namespace
  stage      = var.stage
  attributes = var.attributes
}

resource "aws_apigatewayv2_domain_name" "this" {
  domain_name = var.domain_name
  domain_name_configuration {
    certificate_arn = var.domain_name_configuration.certificate_arn
    endpoint_type   = var.domain_name_configuration.endpoint_type
    security_policy = var.domain_name_configuration.security_policy
  }
  tags = module.label.tags
}

resource "aws_apigatewayv2_api_mapping" "this" {
  for_each        = { for m in var.api_mapping : join("-", [m.api_id, m.stage]) => m }
  api_id          = each.value.api_id
  domain_name     = aws_apigatewayv2_domain_name.this.id
  stage           = each.value.stage
  api_mapping_key = each.value.api_mapping_key
  depends_on      = [aws_apigatewayv2_domain_name.this]
}
