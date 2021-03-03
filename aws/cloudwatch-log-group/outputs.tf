output "arn" {
  value = aws_cloudwatch_log_group.this.arn
}

output "name" {
  value = aws_cloudwatch_log_group.this.name
}

output "metrics" {
  value = { for n, f in var.metric_filters :
    n => {
      id        = aws_cloudwatch_log_metric_filter.this[n].id
      namespace = f.metric_transformation.namespace
    }
  }
}
