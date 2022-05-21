variable "service" {
  type = string
}

variable "env" {
  type = string
}

variable "attributes" {
  type    = list(string)
  default = []
}

variable "name" {
  type    = string
  default = ""
}

variable "add_tags" {
  type    = map(string)
  default = {}
}

variable "associate_public_ip_address" {
  default = false
}

variable "block_device_encrypted" {
  default = true
}

variable "disable_api_termination" {
  default = false
}

variable "ebs_optimized" {
  type    = bool
  default = null
}

variable "enable_monitoring" {
  default = false
}

variable "iam_instance_profile" {
  default = null
}

variable "instance_initiated_shutdown_behavior" {
  default = "terminate"
}

variable "key_name" {
  type    = string
  default = null
}

variable "metadata_options" {
  type = object({
    http_endpoint               = string
    http_tokens                 = string
    http_put_response_hop_limit = number
  })
  default = {
    http_endpoint               = "enabled"
    http_tokens                 = "optional"
    http_put_response_hop_limit = 1
  }
}

variable "network_interfaces" {
  type = list(object({
    network_interface_id = string
    private_ip_address   = string
    security_groups      = list(string)
  }))
  default = []
}

variable "sg_ids" {
  default = []
}

variable "metrics_collection_interval" {
  default = 60
}

variable "cloudwatch_agent_use" {
  default = false
}

variable "root_block_device_size" {
  default = 30
}

variable "userdata_part_cloud_config" {
  default = ""
}

variable "userdata_part_shellscript" {
  default = "echo 'shellscript';"
}
