output "id" {
  value = aws_apigatewayv2_api.this.id
}

output "execution_arn" {
  value = aws_apigatewayv2_api.this.execution_arn
}

output "name" {
  value = aws_apigatewayv2_api.this.name
}

output "target_domain_name" {
  value = try(aws_apigatewayv2_domain_name.this[0].domain_name_configuration[0].target_domain_name, null)
}

output "hosted_zone_id" {
  value = try(aws_apigatewayv2_domain_name.this[0].domain_name_configuration[0].hosted_zone_id, null)
}
