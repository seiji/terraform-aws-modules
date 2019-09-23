# com.amazonaws.region.ssm
data "aws_vpc_endpoint_service" "ssm" {
  service = "ssm"
}

resource "aws_vpc_endpoint" "ssm" {
  count             = var.use_endpoint_ssm ? 1 : 0
  vpc_id            = aws_vpc.this.id
  service_name      = data.aws_vpc_endpoint_service.ssm.service_name
  vpc_endpoint_type = "Interface"

  security_group_ids  = [aws_vpc.this.default_security_group_id]
  subnet_ids          = matchkeys(aws_subnet.private.*.id, aws_subnet.private.*.availability_zone, data.aws_vpc_endpoint_service.ssm.availability_zones)
  private_dns_enabled = true
  tags = {
    name = "ssm-${var.service}-${var.env}"
  }
}

# com.amazonaws.region.ec2messages
# com.amazonaws.region.ec2
# com.amazonaws.region.ssmmessages
