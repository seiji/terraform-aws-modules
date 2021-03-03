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

variable "deployment_controller_type" {
  type    = string
  default = "ECS"
}

variable "deployment_maximum_percent" {
  type    = number
  default = 200
}

variable "deployment_minimum_healthy_percent" {
  type    = number
  default = 100
}

variable "desired_count" {
  type    = number
  default = 0
}

variable "cluster" {
  type = object({
    capacity_providers        = list(string)
    default_capacity_provider = string
  })
  default = {
    capacity_providers        = ["FARGATE", "FARGATE_SPOT"]
    default_capacity_provider = "FARGATE"
  }
}

variable "capacity_provider" {
  type    = string
  default = "FARGATE"
}

variable "health_check_grace_period_seconds" {
  type    = number
  default = 0
}

variable "load_balancers" {
  type = list(object({
    container_name   = string
    container_port   = number
    target_group_arn = string
  }))
  default = []
}

variable "network_configuration" {
  type = object({
    subnets          = list(string)
    security_groups  = list(string)
    assign_public_ip = bool
  })
}

variable "platform_version" {
  type    = string
  default = null
}

variable "task_definition" {
  type = string
}
