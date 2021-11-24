locals {
  template_path = var.cloudwatch_agent_use ? "${path.module}/templates/cloud-init-cwa.yml" : "${path.module}/templates/cloud-init-${var.image_name}.yml"
}

data "template_file" "cloud_init" {
  template = file(local.template_path)

  vars = {
    cwa_content = base64encode(data.template_file.cloudwatch_agent_config.rendered)
    ecs_cluster = var.ecs_cluster_name
  }
}

data "template_file" "cloudwatch_agent_config" {
  template = file("${path.module}/templates/cloudwatch-agent-config.json")

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

