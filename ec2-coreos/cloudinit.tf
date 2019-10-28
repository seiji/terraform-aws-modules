data "template_file" "cloud_init" {
  template = file(var.use_cloudwatch_agent ? "${path.module}/templates/cloud_init_cwa.yml" : "${path.module}/templates/cloud_init.yml")

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


# data "template_cloudinit_config" "merged" {
#   gzip          = true
#   base64_encode = true
#
#   part {
#     filename     = "userdata_part_cloudwatch.cfg"
#     content      = data.template_file.cloud_init.rendered
#     content_type = "text/cloud-config"
#   }
#
#   part {
#     filename     = "userdata_part_caller.cfg"
#     content      = "${var.userdata_part_content}"
#     content_type = "${var.userdata_part_content_type}"
#     merge_type   = "${var.userdata_part_merge_type}"
#   }
# }
