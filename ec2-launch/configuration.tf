resource aws_launch_configuration this {
  name_prefix = "${module.label.id}-"

  associate_public_ip_address = var.associate_public_ip_address
  ebs_optimized               = var.ebs_optimized
  enable_monitoring           = var.enable_monitoring
  iam_instance_profile        = var.iam_instance_profile
  image_id                    = var.image_id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  security_groups             = var.security_groups

  root_block_device {
    volume_size           = var.root_block_device_size
    volume_type           = var.root_block_device_type
    encrypted = true
  }

  user_data_base64 = data.template_cloudinit_config.merged.rendered

  lifecycle {
    create_before_destroy = true
  }
}

