locals {
  use_asg             = true
  autoscaling_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances"
  ]
}

resource "aws_launch_template" "this" {
  count = "${local.use_asg ? 1 : 0}"

  name_prefix = "default"
  key_name    = var.key_name

  iam_instance_profile {
    name = "${aws_iam_instance_profile.ec2.id}"
  }

  image_id = var.image_id

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
  image_id                    = var.image_id
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

resource "aws_autoscaling_group" "this" {
  name                      = "example"
  desired_capacity          = 3
  force_delete              = true
  health_check_grace_period = 300
  health_check_type         = "ELB"
  launch_configuration      = aws_launch_configuration.this.name
  max_size                  = 3
  min_size                  = 3
  vpc_zone_identifier       = var.subnet_private_id_list

  depends_on = [
    "aws_alb.this",
    "aws_launch_configuration.this",
  ]

  target_group_arns = [
    aws_alb_target_group.this.arn,
  ]

  lifecycle {
    create_before_destroy = true
  }

  timeouts {
    delete = "15m"
  }

  tags = [
    {
      key                 = "Name"
      value               = "example"
      propagate_at_launch = true
    },
    {
      key                 = "env"
      value               = "Development"
      propagate_at_launch = true
    },
    {
      key                 = "Type"
      value               = "test"
      propagate_at_launch = true
    }
  ]

  # tags = module.label.tags
}

