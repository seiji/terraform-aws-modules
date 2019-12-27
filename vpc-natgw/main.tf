module "label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=master"
  namespace  = var.namespace
  stage      = var.stage
  attributes = ["nat"]
}

module vpc {
  source                    = "../vpc"
  namespace                 = var.namespace
  stage                     = var.stage
  cidr_block                = var.cidr_block
  azs                       = var.azs
  private_subnets           = var.private_subnets
  public_subnets            = var.public_subnets
  use_endpoint_ssm          = var.use_endpoint_ssm
  use_endpoint_ssm_messages = var.use_endpoint_ssm_messages
  use_endpoint_ec2          = var.use_endpoint_ec2
  use_endpoint_ec2_messages = var.use_endpoint_ec2_messages
  use_endpoint_logs         = var.use_endpoint_logs
  use_endpoint_monitoring   = var.use_endpoint_monitoring
}

resource aws_eip this {
  vpc = true

  tags = module.label.tags
}

resource aws_nat_gateway this {
  allocation_id = aws_eip.this.id
  subnet_id     = module.vpc.public_subnet_ids[0]

  tags       = module.label.tags
  depends_on = [aws_eip.this]
}

resource aws_route this {
  route_table_id         = module.vpc.default_route_table_private_id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this.id
}
