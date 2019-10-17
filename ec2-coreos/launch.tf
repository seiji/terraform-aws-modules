locals {
  use_asg             = true
  autoscaling_metrics = ["GroupMinSize", "GroupMaxSize", "GroupDesiredCapacity", "GroupInServiceInstances", "GroupPendingInstances", "GroupStandbyInstances", "GroupTerminatingInstances", "GroupTotalInstances"]
}

data "aws_ami" "latest_coreos" {
  most_recent = true

  owners = ["595879546273"]

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "name"
    values = ["CoreOS-stable-*"]
  }
}

resource "aws_launch_template" "this" {
  count = "${local.use_asg ? 1 : 0}"

  name_prefix = "default"
  key_name    = var.key_name

  iam_instance_profile {
    name = "${aws_iam_instance_profile.ec2.id}"
  }

  image_id                    = data.aws_ami.latest_coreos.id

  instance_initiated_shutdown_behavior = "terminate"

  lifecycle {
    create_before_destroy = true
  }

  monitoring {
    enabled = true
  }

  network_interfaces {
    associate_public_ip_address = false
  }

  vpc_security_group_ids = var.ec2_security_id_list

  tag_specifications {
    resource_type = "instance"

    tags = module.label.tags
  }

  user_data = data.template_cloudinit_config.merged.rendered
}


resource "aws_launch_configuration" "this" {
  name_prefix                 = "default-"
  associate_public_ip_address = false
  image_id                    = data.aws_ami.latest_coreos.id
  instance_type               = var.instance_type
  iam_instance_profile        = aws_iam_instance_profile.ec2.id
  key_name                    = var.key_name
  security_groups             = var.ec2_security_id_list
  enable_monitoring           = true
  ebs_optimized               = false

  lifecycle {
    create_before_destroy = true
  }

  user_data_base64 = data.template_cloudinit_config.merged.rendered
}

