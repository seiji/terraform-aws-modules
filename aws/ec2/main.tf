terraform {
  required_version = ">= 0.12.0"
}

provider "aws" {
  version = "~> 2.28"
  region = var.region
}

data "aws_ami" "recent_amazon_linux2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.????????-x86_64-gp2"]
  }
  filter {
    name   = "state"
    values = ["available"]
  }
}

module "label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=master"
  namespace  = "namespace"
  stage      = "prod"
  name       = "name"
  attributes = ["public"]
  delimiter  = "-"

  tags = {
    "BusinessUnit" = "XYZ",
    "Snapshot"     = "true"
  }
}

resource "aws_instance" "this" {
  count         = length(var.subnet_id_list)
  ami           = data.aws_ami.recent_amazon_linux2.image_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id_list[count.index]
  vpc_security_group_ids = var.security_id_list
  associate_public_ip_address = var.associate_public_ip_address
  key_name      = var.key_name

  iam_instance_profile = "${aws_iam_instance_profile.ec2.id}"
  tags = module.label.tags

  user_data = <<EOF
#cloud-config
repo_update: true
repo_upgrade: none
runcmd:
 - yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
EOF
}
