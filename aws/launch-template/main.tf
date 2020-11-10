module label {
  source     = "../../label"
  service    = var.service
  env        = var.env
  attributes = var.attributes
  name       = var.name
  add_tags   = var.add_tags
}

resource aws_launch_template this {
  name = module.label.id
  dynamic block_device_mappings {
    for_each = var.block_device_mappings
    content {
      device_name = block_device_mappings.value.device_name
      ebs {
        volume_size           = block_device_mappings.value.ebs.volume_size
        volume_type           = block_device_mappings.value.ebs.volume_type
        delete_on_termination = block_device_mappings.value.ebs.delete_on_termination
      }
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
  network_interfaces {
    associate_public_ip_address = var.associate_public_ip_address
  }
  user_data              = var.userdata
  vpc_security_group_ids = var.sg_ids

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

