output "id" {
  value = aws_apigatewayv2_api.this.id
}

output "target_domain_name" {
  value = var.domain_name != null ? aws_apigatewayv2_domain_name.this[0].domain_name_configuration[0].target_domain_name : null
}

output "hosted_zone_id" {
  value = var.domain_name != null ? aws_apigatewayv2_domain_name.this[0].domain_name_configuration[0].hosted_zone_id : null
}
