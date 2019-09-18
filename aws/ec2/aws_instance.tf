variable "region" {
  description = "region"
  type        = string
  default     = "ap-northeast-1"
}

provider "aws" {
  region = var.region
}

variable "service" {}
variable "env" {}
variable "name" {}
variable "instance_type" {}
variable "subnet_id" {}
variable "security_ids" {}

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

resource "aws_instance" "example" {
  ami           = data.aws_ami.recent_amazon_linux2.image_id
  instance_type = "${var.instance_type}"
  subnet_id     = "${var.subnet_id}"
  vpc_security_group_ids = "${var.security_ids}"
  associate_public_ip_address = true
  key_name      = "id_rsa"

  tags = {
    Name    = "ec2-${var.service}-${var.env}-${var.name}"
    service = "${var.service}"
    env     = "${var.env}"
  }

  user_data = <<EOF
    #!/bin/bash
    yum install -y httpd
    echo "test" >/var/www/html/index.html
    systemctl start httpd.service
EOF
}

output "example_public_dns" {
  value = aws_instance.example.public_dns
}
