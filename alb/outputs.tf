output lb_dns_name {
  value = aws_alb.this.dns_name
}

output lb_zone_id {
  value = aws_alb.this.zone_id
}

output tg_arn {
  value = aws_alb_target_group.this.arn
}
