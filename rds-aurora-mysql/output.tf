output "instance_ids" {
  value = aws_rds_cluster_instance.this.*.identifier
}

output "ssm_password_name" {
  value = aws_ssm_parameter.password.name
}
