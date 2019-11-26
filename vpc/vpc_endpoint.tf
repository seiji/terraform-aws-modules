# com.amazonaws.region.ssm
data aws_vpc_endpoint_service ssm {
  count   = var.use_endpoint_ssm ? 1 : 0
  service = "ssm"
}

resource aws_vpc_endpoint ssm {
  count             = var.use_endpoint_ssm ? 1 : 0
  vpc_id            = aws_vpc.this.id
  service_name      = data.aws_vpc_endpoint_service.ssm[count.index].service_name
  vpc_endpoint_type = "Interface"

  security_group_ids  = [aws_vpc.this.default_security_group_id]
  subnet_ids          = matchkeys(aws_subnet.private.*.id, aws_subnet.private.*.availability_zone, data.aws_vpc_endpoint_service.ssm[count.index].availability_zones)
  private_dns_enabled = true

  tags = module.label.tags
}

# com.amazonaws.region.ssmmessages
data aws_vpc_endpoint_service ssm_messages {
  count   = var.use_endpoint_ssm_messages ? 1 : 0
  service = "ssmmessages"
}

resource aws_vpc_endpoint ssm_messages {
  count             = var.use_endpoint_ssm_messages ? 1 : 0
  vpc_id            = aws_vpc.this.id
  service_name      = data.aws_vpc_endpoint_service.ssm_messages[count.index].service_name
  vpc_endpoint_type = "Interface"

  security_group_ids  = [aws_vpc.this.default_security_group_id]
  subnet_ids          = matchkeys(aws_subnet.private.*.id, aws_subnet.private.*.availability_zone, data.aws_vpc_endpoint_service.ssm_messages[count.index].availability_zones)
  private_dns_enabled = true

  tags = module.label.tags
}
# com.amazonaws.region.ec2
data aws_vpc_endpoint_service ec2 {
  count   = var.use_endpoint_ec2 ? 1 : 0
  service = "ec2"
}

resource aws_vpc_endpoint ec2 {
  count             = var.use_endpoint_ec2 ? 1 : 0
  vpc_id            = aws_vpc.this.id
  service_name      = data.aws_vpc_endpoint_service.ec2[count.index].service_name
  vpc_endpoint_type = "Interface"

  security_group_ids  = [aws_vpc.this.default_security_group_id]
  subnet_ids          = matchkeys(aws_subnet.private.*.id, aws_subnet.private.*.availability_zone, data.aws_vpc_endpoint_service.ec2[count.index].availability_zones)
  private_dns_enabled = true

  tags = module.label.tags
}

# com.amazonaws.region.ec2messages
data aws_vpc_endpoint_service ec2_messages {
  count   = var.use_endpoint_ec2_messages ? 1 : 0
  service = "ec2messages"
}

resource aws_vpc_endpoint ec2_messages {
  count             = var.use_endpoint_ec2_messages ? 1 : 0
  vpc_id            = aws_vpc.this.id
  service_name      = data.aws_vpc_endpoint_service.ec2_messages[count.index].service_name
  vpc_endpoint_type = "Interface"

  security_group_ids  = [aws_vpc.this.default_security_group_id]
  subnet_ids          = matchkeys(aws_subnet.private.*.id, aws_subnet.private.*.availability_zone, data.aws_vpc_endpoint_service.ec2_messages[count.index].availability_zones)
  private_dns_enabled = true

  tags = module.label.tags
}

# com.amazonaws.region.logs
data aws_vpc_endpoint_service logs {
  count   = var.use_endpoint_logs ? 1 : 0
  service = "logs"
}

resource aws_vpc_endpoint logs {
  count             = var.use_endpoint_logs ? 1 : 0
  vpc_id            = aws_vpc.this.id
  service_name      = data.aws_vpc_endpoint_service.logs[count.index].service_name
  vpc_endpoint_type = "Interface"

  security_group_ids  = [aws_vpc.this.default_security_group_id]
  subnet_ids          = matchkeys(aws_subnet.private.*.id, aws_subnet.private.*.availability_zone, data.aws_vpc_endpoint_service.logs[count.index].availability_zones)
  private_dns_enabled = true

  tags = module.label.tags
}

# com.amazonaws.region.monitoring
data aws_vpc_endpoint_service monitoring {
  count   = var.use_endpoint_monitoring ? 1 : 0
  service = "monitoring"
}

resource aws_vpc_endpoint monitoring {
  count             = var.use_endpoint_monitoring ? 1 : 0
  vpc_id            = aws_vpc.this.id
  service_name      = data.aws_vpc_endpoint_service.monitoring[count.index].service_name
  vpc_endpoint_type = "Interface"

  security_group_ids  = [aws_vpc.this.default_security_group_id]
  subnet_ids          = matchkeys(aws_subnet.private.*.id, aws_subnet.private.*.availability_zone, data.aws_vpc_endpoint_service.monitoring[count.index].availability_zones)
  private_dns_enabled = true

  tags = module.label.tags
}
