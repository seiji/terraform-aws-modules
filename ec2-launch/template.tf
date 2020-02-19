resource aws_launch_template this {
  name = module.label.id

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
  instance_initiated_shutdown_behavior = "terminate"
  key_name                             = var.key_name

  monitoring {
    enabled = var.enable_monitoring
  }

  user_data              = data.template_cloudinit_config.merged.rendered
  vpc_security_group_ids = var.security_groups

  tag_specifications {
    resource_type = "instance"
    tags          = module.label.tags
  }

  tag_specifications {
    resource_type = "volume"
    tags          = module.label.tags
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = module.label.tags
}
