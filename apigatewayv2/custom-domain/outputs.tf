output id {
  value = aws_apigatewayv2_domain_name.this.id
}

output hosted_zone_id {
  value = aws_apigatewayv2_domain_name.this.domain_name_configuration.0.hosted_zone_id
}

output target_domain_name {
  value = aws_apigatewayv2_domain_name.this.domain_name_configuration.0.target_domain_name
}
