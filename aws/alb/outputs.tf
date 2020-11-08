output id {
  value = aws_alb.this.id
}

output arn_suffix {
  value = aws_alb.this.arn_suffix
}

output dns_name {
  value = aws_alb.this.dns_name
}

output zone_id {
  value = aws_alb.this.zone_id
}

output target_groups {
  value = {
    for name, tg in aws_alb_target_group.this :
    name => {
      arn  = tg.arn
      name = tg.name
      port = tg.port
    }
  }
}
