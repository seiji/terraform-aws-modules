locals {
  instance_type = "t3.nano"
}

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

data aws_ami nat {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-vpc-nat-hvm-*-x86_64-ebs"]
  }
  filter {
    name   = "state"
    values = ["available"]
  }
}

resource aws_eip this {
  vpc = true

  tags = module.label.tags
}

# resource aws_instance nati {
resource aws_spot_instance_request this {
  ami                    = data.aws_ami.nat.image_id
  instance_type          = local.instance_type
  subnet_id              = module.vpc.public_subnet_ids[0]
  vpc_security_group_ids = [module.vpc.default_security_group_id]
  source_dest_check      = false

  spot_price           = "0.02"
  spot_type            = "one-time"
  wait_for_fulfillment = true
  tags                 = module.label.tags

  provisioner "local-exec" {
    command = "aws ec2 modify-instance-attribute --instance-id ${aws_spot_instance_request.this.spot_instance_id}  --no-source-dest-check"
  }
}

resource aws_eip_association this {
  instance_id   = aws_spot_instance_request.this.spot_instance_id
  allocation_id = aws_eip.this.id
  depends_on    = [aws_spot_instance_request.this, aws_eip.this]
}

resource aws_route this {
  route_table_id         = module.vpc.default_route_table_private_id
  destination_cidr_block = "0.0.0.0/0"
  instance_id            = aws_spot_instance_request.this.spot_instance_id
}
