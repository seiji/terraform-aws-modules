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

resource "aws_apigatewayv2_vpc_link" "this" {
  count              = var.vpc_link != null ? 1 : 0
  name               = module.label.id
  security_group_ids = var.vpc_link.security_group_ids
  subnet_ids         = var.vpc_link.subnet_ids
  tags               = module.label.tags
}

resource "aws_apigatewayv2_integration" "this" {
  for_each               = var.integrations
  api_id                 = aws_apigatewayv2_api.this.id
  connection_id          = try(aws_apigatewayv2_vpc_link.this[0].id, null)
  connection_type        = each.value.connection_type
  integration_method     = each.value.integration_method
  integration_type       = each.value.integration_type
  integration_uri        = each.value.integration_uri
  payload_format_version = each.value.payload_format_version
  depends_on             = [aws_apigatewayv2_vpc_link.this]
}

resource "aws_apigatewayv2_route" "this" {
  for_each   = { for r in var.routes : r.route_key => r }
  api_id     = aws_apigatewayv2_api.this.id
  route_key  = each.value.route_key
  target     = "integrations/${aws_apigatewayv2_integration.this[each.value.integration_key].id}"
  depends_on = [aws_apigatewayv2_integration.this]
}

resource "aws_apigatewayv2_deployment" "this" {
  count       = length(var.routes) > 0 ? 1 : 0
  api_id      = aws_apigatewayv2_api.this.id
  description = "Automatic deployment triggered by changes to the Api configuration"
  lifecycle {
    create_before_destroy = true
  }
  depends_on = [aws_apigatewayv2_route.this]
}

resource "aws_apigatewayv2_stage" "this" {
  count         = length(var.routes) > 0 ? 1 : 0
  api_id        = aws_apigatewayv2_api.this.id
  name          = "$default"
  auto_deploy   = true
  deployment_id = aws_apigatewayv2_deployment.this[0].id
  dynamic "access_log_settings" {
    for_each = var.access_log_settings != null ? [var.access_log_settings] : []
    content {
      destination_arn = access_log_settings.value.destination_arn
      format          = access_log_settings.value.format
    }
  }
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
  stage       = aws_apigatewayv2_stage.this[0].name
  depends_on  = [aws_apigatewayv2_domain_name.this]
}

resource "aws_lambda_permission" "this" {
  count         = var.lambda_permission != null ? 1 : 0
  statement_id  = var.lambda_permission.statement_id
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_permission.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.this.execution_arn}/*/*${var.lambda_permission.source_path}"
  depends_on    = [aws_apigatewayv2_api.this]
}
