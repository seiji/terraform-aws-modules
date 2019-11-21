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
    filename     = "userdata_part_cloudwatch.cfg"
    content      = data.template_file.cloud_init.rendered
    content_type = "text/cloud-config"
  }

  part {
    filename     = "userdata_part_caller.cfg"
    content      = "${var.userdata_part_content}"
    content_type = "${var.userdata_part_content_type}"
    merge_type   = "${var.userdata_part_merge_type}"
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
  enable_monitoring           = true
  ebs_optimized               = false

  lifecycle {
    create_before_destroy = true
  }

  user_data_base64 = data.template_cloudinit_config.merged.rendered
}
