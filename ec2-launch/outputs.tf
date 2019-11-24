output configuration_name {
  value = aws_launch_configuration.this.name
}

output template_id {
  value = aws_launch_template.this.id
}
