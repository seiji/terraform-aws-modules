locals {
  use_asg             = true
  autoscaling_metrics = ["GroupMinSize", "GroupMaxSize", "GroupDesiredCapacity", "GroupInServiceInstances", "GroupPendingInstances", "GroupStandbyInstances", "GroupTerminatingInstances", "GroupTotalInstances"]
}

resource "aws_launch_template" "this" {
  count = "${local.use_asg ? 1 : 0}"

  name_prefix = "default"
  key_name    = var.key_name

  iam_instance_profile {
    name = "${aws_iam_instance_profile.ec2.id}"
  }

  image_id = data.aws_ami.recent_amazon_linux2.image_id

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

  vpc_security_group_ids = var.security_id_list

  tag_specifications {
    resource_type = "instance"

    tags = module.label.tags
  }

  user_data = var.use_cloudwatch_agent ? data.template_file.cloud_init.rendered : ""
}


resource "aws_launch_configuration" "this" {

  name_prefix = "default"

  associate_public_ip_address = false

  enable_monitoring = true

  iam_instance_profile = aws_iam_instance_profile.ec2.id

  image_id = data.aws_ami.recent_amazon_linux2.image_id

  instance_type = var.instance_type

  key_name = var.key_name

  lifecycle {
    create_before_destroy = true
  }

  security_groups = var.security_id_list

  user_data_base64 = var.use_cloudwatch_agent ? data.template_file.cloud_init.rendered : ""
}

resource "aws_autoscaling_group" "bar" {
  name                      = "example"
  max_size                  = 3
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 2
  force_delete              = true
  placement_group           = aws_placement_group.test.id
  launch_configuration      = aws_launch_configuration.this.name
  vpc_zone_identifier       = var.subnet_id_list

#   initial_lifecycle_hook {
#     name                 = "foobar"
#     default_result       = "CONTINUE"
#     heartbeat_timeout    = 2000
#     lifecycle_transition = "autoscaling:EC2_INSTANCE_LAUNCHING"
#
#     notification_metadata = <<EOF
# {
#   "foo": "bar"
# }
# EOF
#
#     notification_target_arn = "arn:aws:sqs:us-east-1:444455556666:queue1*"
#     role_arn                = "arn:aws:iam::123456789012:role/S3Access"
#   }

  timeouts {
    delete = "15m"
  }

  # tags = module.label.tags
}

resource "aws_placement_group" "test" {
  name     = "example"
  strategy = "cluster"
}
