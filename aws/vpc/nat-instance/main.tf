module "label" {
  source     = "../../../label"
  service    = var.service
  env        = var.env
  attributes = var.attributes
  name       = var.name
  add_tags   = var.add_tags
}

data "aws_ami" "this" {
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

resource "aws_eip" "this" {
  vpc  = true
  tags = module.label.tags
}

resource "aws_spot_instance_request" "this" {
  ami                    = data.aws_ami.this.image_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids
  source_dest_check      = false
  spot_price             = var.spot_price
  spot_type              = "one-time"
  wait_for_fulfillment   = true
  tags                   = module.label.tags
  provisioner "local-exec" {
    command = "aws ec2 modify-instance-attribute --instance-id ${aws_spot_instance_request.this.spot_instance_id}  --no-source-dest-check"
  }
}

resource "aws_eip_association" "this" {
  instance_id   = aws_spot_instance_request.this.spot_instance_id
  allocation_id = aws_eip.this.id
  depends_on    = [aws_spot_instance_request.this, aws_eip.this]
}

# resource "aws_route" "this" {
#   route_table_id         = module.vpc.default_route_table_private_id
#   destination_cidr_block = "0.0.0.0/0"
#   instance_id            = aws_spot_instance_request.this.spot_instance_id
#   depends_on             = [aws_spot_instance_request.this]
# }
