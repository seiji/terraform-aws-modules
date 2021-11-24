variable "namespace" {
  type = string
}

variable "stage" {
  type = string
}

variable "name" {
  type = string
}

variable "max_size" {
  default = 1
}

variable "min_size" {
  default = 0
}

variable "desired_capacity" {
  default = 0
}

variable "health_check_grace_period" {
  default = 300
}

variable "health_check_type" {
  default = "EC2"
}

variable "launch_configuration" {
  type = string
}

variable "target_group_arns" {
  default = []
}

variable "vpc_zone_identifier" {
  type = list(any)
}

variable "policy_target_tracking" {
  type = object({
    predefined_metric_type = string
    disable_scale_in       = bool
    target_value           = number
  })

  default = {
    predefined_metric_type = "ASGAverageCPUUtilization"
    disable_scale_in       = true
    target_value           = 50.0
  }
}
