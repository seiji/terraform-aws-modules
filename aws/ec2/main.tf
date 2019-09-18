terraform {
  required_version = ">= 0.12.0"
}

provider "aws" {
  version = "~> 2.22"
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

resource "aws_instance" "this" {
  count         = length(var.subnet_id_list)
  ami           = data.aws_ami.recent_amazon_linux2.image_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id_list[count.index]
  vpc_security_group_ids = var.security_id_list
  associate_public_ip_address = var.associate_public_ip_address
  key_name      = var.key_name

  iam_instance_profile = "${aws_iam_instance_profile.ssm.id}"

  tags = {
    Name    = "${var.service}-${var.env}-${var.name}${count.index}"
    service = var.service
    env     = var.env
  }
  user_data = <<EOF
  #!/bin/bash
  cd /tmp
  sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
  sudo systemctl start amazon-ssm-agent
  ${var.user_data}
EOF
}

