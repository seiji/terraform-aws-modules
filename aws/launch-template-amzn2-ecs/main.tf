module "label" {
  source     = "../../label"
  service    = var.service
  env        = var.env
  attributes = var.attributes
  name       = var.name
  add_tags   = var.add_tags
}

data "aws_ssm_parameter" "ecs_optimized_amzn2_image_id" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended/image_id"
}

resource "aws_launch_template" "this" {
  name = module.label.id

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = var.root_block_device_size
      volume_type           = "gp2"
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

  image_id                             = data.aws_ssm_parameter.ecs_optimized_amzn2_image_id.value
  instance_initiated_shutdown_behavior = "terminate"
  key_name                             = var.key_name

  monitoring {
    enabled = var.enable_monitoring
  }

  user_data              = data.template_cloudinit_config.merged.rendered
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

