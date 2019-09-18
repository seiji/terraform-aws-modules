variable "region" {
  description = "region"
  type        = string
  default     = "ap-northeast-1"
}

provider "aws" {
  region = var.region
}

variable "service" {}
variable "env" {}
variable "name" {}

resource "aws_ecs_task_definition" "this" {
  family = "${var.service}-${var.env}-${var.name}"

  requires_compatibilities = ["FARGATE"]

  cpu    = "256"
  memory = "512"

  network_mode = "awsvpc" # Fargate

  container_definitions = <<EOS
[
  {
    "name": "nginx",
    "image": "nginx:1.14",
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80
      }
    ]
  }
]
EOS
  tags = {
    Name    = "ecs-taskdef-${var.service}-${var.env}-${var.name}"
    service = "${var.service}"
    env     = "${var.env}"
  }
}

resource "aws_ecs_cluster" "this" {
  name = "${var.service}-${var.env}-${var.name}"
}
