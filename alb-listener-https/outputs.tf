output dns_name {
  value = aws_alb.this.dns_name
}

output zone_id {
  value = aws_alb.this.zone_id
}
