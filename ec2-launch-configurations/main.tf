data "template_file" "cloud_init" {
  template = file(var.cloudwatch_agent_use ? "${path.module}/templates/cloud_init_cwa.yml" : "${path.module}/templates/cloud_init.yml")

  vars = {
    cwa_content = base64encode(data.template_file.cloudwatch_agent_config.rendered)
  }
}

data "template_file" "cloudwatch_agent_config" {
  template = file("${path.module}/templates/cloudwatch_agent_config.json")

  vars = {
    metrics_collection_interval = "${var.metrics_collection_interval}"
  }
}

data "template_cloudinit_config" "merged" {
  gzip          = true
  base64_encode = true

  part {
    filename     = "userdata_part_cloudinit.cfg"
    content      = data.template_file.cloud_init.rendered
    content_type = "text/cloud-config"
  }

  part {
    filename     = "userdata_part_caller_cloudinit.cfg"
    content      = var.userdata_part_cloud_config
    content_type = "text/cloud-config"
    merge_type   = "list(append)+dict(recurse_array)+str()"
  }

  part {
    filename     = "userdata_part_caller_shellscript.cfg"
    content      = var.userdata_part_shellscript
    content_type = "text/x-shellscript"
    merge_type   = "list(append)+dict(recurse_array)+str()"
  }
}

resource "aws_launch_configuration" "this" {
  name_prefix                 = "${var.name}-"
  associate_public_ip_address = var.associate_public_ip_address
  image_id                    = var.image_id
  instance_type               = var.instance_type
  iam_instance_profile        = var.iam_instance_profile
  key_name                    = var.key_name
  security_groups             = var.security_groups
  enable_monitoring           = false
  ebs_optimized               = true

  lifecycle {
    create_before_destroy = true
  }

  root_block_device {
    encrypted = true
  }

  user_data_base64 = data.template_cloudinit_config.merged.rendered
}