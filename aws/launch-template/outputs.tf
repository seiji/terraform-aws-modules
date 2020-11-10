output template_id {
  value = aws_launch_template.this.id
}

output template_name {
  value = aws_launch_template.this.name
}

output template_default_version {
  value = aws_launch_template.this.default_version
}

output template_latest_version {
  value = aws_launch_template.this.latest_version
}
