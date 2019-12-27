variable namespace {
  type = string
}

variable stage {
  type = string
}

variable cidr_block {
  type = string
}

variable azs {
  type = list
}

variable private_subnets {
  type = list
}

variable public_subnets {
  type = list
}

variable use_natgw {
  default = false
}

variable use_endpoint_ssm {
  default = false
}

variable use_endpoint_ssm_messages {
  default = false
}

variable use_endpoint_ec2 {
  default = false
}

variable use_endpoint_ec2_messages {
  default = false
}

variable use_endpoint_logs {
  default = false
}

variable use_endpoint_monitoring {
  default = false
}
