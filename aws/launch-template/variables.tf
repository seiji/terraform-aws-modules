variable service {
  type = string
}

variable env {
  type = string
}

variable attributes {
  type    = list(string)
  default = []
}

variable name {
  type    = string
  default = ""
}

variable add_tags {
  type    = map(string)
  default = {}
}

variable associate_public_ip_address {
  type    = bool
  default = false
}

variable disable_api_termination {
  type    = bool
  default = false
}

variable ebs_optimized {
  type    = bool
  default = false
}

variable enable_monitoring {
  type    = bool
  default = false
}

variable image_id {
  type = string
}

variable iam_instance_profile {
  type    = string
  default = null
}

variable key_name {
  type    = string
  default = null
}

variable sg_ids {
  type    = list(string)
  default = []
}

variable block_device_mappings {
  type = list(object({
    device_name = string
    ebs = object({
      volume_size           = number
      volume_type           = string
      delete_on_termination = bool
    })
  }))
  default = [
    {
      device_name = "/dev/xvda"
      ebs = {
        volume_size           = 8
        volume_type           = "gp2"
        delete_on_termination = true
      }
    }
  ]
}

variable userdata {
  type    = string
  default = null
}
