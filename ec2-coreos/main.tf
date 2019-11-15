module "label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=master"
  namespace  = "namespace"
  stage      = "prod"
  name       = "name"
  attributes = ["private"]
  delimiter  = "-"

  tags = {
    "BusinessUnit" = "XYZ",
  }
}

data "aws_ami" "latest_coreos" {
  most_recent = true

  owners = ["595879546273"]

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "name"
    values = ["CoreOS-stable-*"]
  }
}


resource "aws_instance" "this" {
  ami                         = data.aws_ami.latest_coreos.image_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_public_id_list[0]
  vpc_security_group_ids      = var.ec2_security_id_list
  associate_public_ip_address = var.associate_public_ip_address
  key_name                    = var.key_name

  iam_instance_profile = "${aws_iam_instance_profile.ec2.id}"
  tags                 = module.label.tags

  user_data = data.template_file.cloud_init.rendered
}

