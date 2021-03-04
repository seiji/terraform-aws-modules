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

variable deployment_config_name {
  type    = string
  default = "CodeDeployDefault.ECSAllAtOnce"
}

variable service_role_arn {
  type = string
}

variable ecs_service {
  type = object({
    cluster_name = string
    service_name = string
  })
}

variable load_balancer_info {
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
