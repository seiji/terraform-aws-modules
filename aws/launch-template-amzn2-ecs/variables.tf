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

variable "disable_api_termination" {
  default = false
}

variable "ebs_optimized" {
  default = false
}

variable "enable_monitoring" {
  default = false
}

variable "iam_instance_profile" {
  default = null
}

variable "key_name" {
  type    = string
  default = null
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

variable "ecs_cluster_name" {
  default = "default"
}

