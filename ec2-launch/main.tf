resource aws_launch_configuration this {
  name_prefix                 = "${var.name}-"
  associate_public_ip_address = var.associate_public_ip_address
  image_id                    = var.image_id
  instance_type               = var.instance_type
  iam_instance_profile        = var.iam_instance_profile
  key_name                    = var.key_name
  security_groups             = var.security_groups
  enable_monitoring           = var.enable_monitoring
  ebs_optimized               = var.ebs_optimized

  lifecycle {
    create_before_destroy = true
  }

  root_block_device {
    encrypted = true
  }

  user_data_base64 = data.template_cloudinit_config.merged.rendered
}

resource aws_launch_template this {
  name = var.name

  block_device_mappings {
    device_name = var.ami_block_device_mappings[0]["device_name"]

    ebs {
      volume_size           = var.root_block_device_size
      volume_type           = var.root_block_device_type
      delete_on_termination = true
    }
  }

  capacity_reservation_specification {
    capacity_reservation_preference = "open"
  }

  disable_api_termination = var.disable_api_termination
  ebs_optimized           = var.ebs_optimized

  iam_instance_profile {
    name = var.iam_instance_profile
  }

  image_id                             = var.image_id
  instance_initiated_shutdown_behavior = "stop"


  key_name = var.key_name
  monitoring {
    enabled = var.enable_monitoring
  }

  network_interfaces {
    associate_public_ip_address = var.associate_public_ip_address
  }

  vpc_security_group_ids = var.security_groups

  # tag_specifications {
  #   resource_type = "instance"
  #   tags = module.label.tags
  # }

  lifecycle {
    create_before_destroy = true
  }

  user_data = data.template_cloudinit_config.merged.rendered
}
