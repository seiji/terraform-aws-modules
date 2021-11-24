module "label" {
  source     = "../../../label"
  service    = var.service
  env        = var.env
  attributes = var.attributes
  name       = var.name
  add_tags   = var.add_tags
}

resource "aws_apigatewayv2_api" "this" {
  name                         = module.label.id
  description                  = var.description
  disable_execute_api_endpoint = var.disable_execute_api_endpoint
  protocol_type                = "HTTP"
  dynamic "cors_configuration" {
    for_each = var.cors_configuration != null ? [var.cors_configuration] : []
    content {
      allow_credentials = cors_configuration.value.allow_credentials
      allow_headers     = cors_configuration.value.allow_headers
      allow_methods     = cors_configuration.value.allow_methods
      allow_origins     = cors_configuration.value.allow_origins
      expose_headers    = cors_configuration.value.expose_headers
      max_age           = cors_configuration.value.max_age
    }
  }
  tags = module.label.tags
}

resource "aws_apigatewayv2_integration" "this" {
  for_each               = { for i in var.integrations : i.connection_id => i }
  api_id                 = aws_apigatewayv2_api.this.id
  connection_id          = each.value.connection_type != "INTERNET" ? each.value.connection_id : null
  connection_type        = each.value.connection_type
  credentials_arn        = each.value.credentials_arn
  integration_method     = each.value.integration_method
  integration_type       = each.value.integration_type
  integration_subtype    = each.value.integration_subtype
  integration_uri        = each.value.integration_uri
  payload_format_version = each.value.payload_format_version
  request_parameters     = each.value.request_parameters
}

resource "aws_apigatewayv2_route" "this" {
  for_each   = { for r in var.routes : r.route_key => r }
  api_id     = aws_apigatewayv2_api.this.id
  route_key  = each.value.route_key
  target     = "integrations/${aws_apigatewayv2_integration.this[each.value.target_key].id}"
  depends_on = [aws_apigatewayv2_integration.this]
}

resource "aws_apigatewayv2_deployment" "this" {
  api_id      = aws_apigatewayv2_api.this.id
  description = "Automatic deployment triggered by changes to the Api configuration"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_apigatewayv2_stage" "this" {
  api_id        = aws_apigatewayv2_api.this.id
  name          = "$default"
  auto_deploy   = true
  deployment_id = aws_apigatewayv2_deployment.this.id
  lifecycle {
    ignore_changes = [deployment_id, default_route_settings]
  }
  tags = module.label.tags
}

resource "aws_apigatewayv2_domain_name" "this" {
  count       = var.domain_name != null ? 1 : 0
  domain_name = var.domain_name.domain_name
  dynamic "domain_name_configuration" {
    for_each = [var.domain_name.domain_name_configuration]
    content {
      certificate_arn = domain_name_configuration.value.certificate_arn
      endpoint_type   = domain_name_configuration.value.endpoint_type
      security_policy = domain_name_configuration.value.security_policy
    }
  }
  tags = module.label.tags
}

resource "aws_apigatewayv2_api_mapping" "this" {
  count       = var.domain_name != null ? 1 : 0
  api_id      = aws_apigatewayv2_api.this.id
  domain_name = aws_apigatewayv2_domain_name.this[0].id
  stage       = aws_apigatewayv2_stage.this.name
  depends_on  = [aws_apigatewayv2_domain_name.this]
}
