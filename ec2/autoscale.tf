locals {
  use_asg = true
}

resource "aws_launch_template" "this" {
  count = "${local.use_asg ? 1 : 0}"

  name_prefix = "default"
  image_id    = data.aws_ami.recent_amazon_linux2.image_id
  key_name    = var.key_name

  vpc_security_group_ids = var.security_id_list
  iam_instance_profile {
    name = "${aws_iam_instance_profile.ec2.id}"
  }

  monitoring {
    enabled = true
  }

  tags = module.label.tags
  lifecycle {
    create_before_destroy = true
  }
}
