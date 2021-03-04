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

variable "auto_rollback_configuration" {
  type = object({
    enabled = bool
    events  = list(string)
  })
  default = {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }
}

variable "blue_green_deployment_config" {
  type = object({
    deployment_ready_option = object({
      action_on_timeout    = string
      wait_time_in_minutes = number
    })
    terminate_blue_instances_on_deployment_success = object({
      action                           = string
      termination_wait_time_in_minutes = number
    })
  })
  default = null
}

variable "compute_platform" {
  type    = string
  default = "ECS"
}

variable "deployment_config_name" {
  type    = string
  default = "CodeDeployDefault.ECSAllAtOnce"
}

variable "deployment_style" {
  type = object({
    deployment_option = string
    deployment_type   = string
  })
  default = {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }
}

variable "ecs_service" {
  type = object({
    cluster_name = string
    service_name = string
  })
}

variable "load_balancer_info" {
  type = object({
    target_group_info = object({
      name = string
    })
    target_group_pair_info = object({
      prod_listener_arns = list(string)
      target_group_names = list(string)
      test_listener_arns = list(string)
    })
  })
}

variable "service_role_arn" {
  type = string
}
