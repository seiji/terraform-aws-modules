variable namespace {
  type = string
}

variable stage {
  type = string
}

variable associate_public_ip_address {
  default = false
}

variable ami_block_device_mappings {
  type = list
}

variable disable_api_termination {
  default = false
}

variable ebs_optimized {
  default = false
}

variable enable_monitoring {
  default = false
}

variable image_id {
  type = string
}

variable instance_type {
  default = "t3.micro"
}

variable iam_instance_profile {
  type = string
}

variable key_name {
  type = string
}

variable security_groups {
  default = []
}

variable metrics_collection_interval {
  default = 60
}

variable cloudwatch_agent_use {
  default = false
}

variable root_block_device_size {
  default = 8
}

variable root_block_device_type {
  default = "gp2"
}

variable spot_price {
  default = null
}

variable userdata_part_cloud_config {
  default = ""
}

variable userdata_part_shellscript {
  default = "echo 'shellscript';"
}
