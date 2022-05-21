module "label" {
  source     = "../../label"
  service    = var.service
  env        = var.env
  attributes = var.attributes
  name       = var.name
  add_tags   = var.add_tags
}

data "aws_ssm_parameter" "amzn2_image_id" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-kernel-5.10-hvm-x86_64-gp2"
}

resource "aws_launch_template" "this" {
  name = module.label.id

  block_device_mappings {
    device_name = "/dev/xvda"
    no_device   = true
    ebs {
      volume_size           = var.root_block_device_size
      volume_type           = "gp2"
      delete_on_termination = true
      encrypted             = var.block_device_encrypted
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

  image_id                             = nonsensitive(data.aws_ssm_parameter.amzn2_image_id.value)
  instance_initiated_shutdown_behavior = var.instance_initiated_shutdown_behavior
  key_name                             = var.key_name

  metadata_options {
    http_endpoint               = var.metadata_options.http_endpoint
    http_tokens                 = var.metadata_options.http_tokens
    http_put_response_hop_limit = var.metadata_options.http_put_response_hop_limit
  }

  monitoring {
    enabled = var.enable_monitoring
  }

  dynamic "network_interfaces" {
    for_each = var.network_interfaces
    content {
      network_interface_id = network_interfaces.value.network_interface_id
      private_ip_address   = network_interfaces.value.private_ip_address
      security_groups      = network_interfaces.value.security_groups
    }
  }
  update_default_version = true
  user_data              = data.template_cloudinit_config.merged.rendered
  vpc_security_group_ids = var.sg_ids

  tag_specifications {
    resource_type = "instance"
    tags          = module.label.tags
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = module.label.tags
}

