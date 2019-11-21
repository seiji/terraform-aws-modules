variable namespace {
  type = string
}

variable stage {
  type = string
}

variable name {
  type = string
}

variable image_id {
  type = string
}

variable instance_type {
  default = "t3a.micro"
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

variable enable_monitoring {
  default = true
}

variable ebs_optimized {
  default = false
}

variable metrics_collection_interval {
  default = 60
}

variable cloudwatch_agent_use {
  default = false
}

variable userdata_part_content {
  default = ""
}

variable userdata_part_content_type {
  default = "text/cloud-config"
}

variable userdata_part_merge_type {
  default = "list(append)+dict(recurse_array)+str()"
}

