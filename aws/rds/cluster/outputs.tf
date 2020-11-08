output id {
  value = aws_rds_cluster.this.id
}

output endpoint {
  value = aws_rds_cluster.this.endpoint
}

output reader_endpoint {
  value = aws_rds_cluster.this.reader_endpoint
}
