module label {
  source     = "../../label"
  service    = var.service
  env        = var.env
  attributes = var.attributes
  name       = var.name
  add_tags   = var.add_tags
}

data aws_ecs_task_definition this {
  task_definition = var.task_definition
}

resource aws_ecs_cluster this {
  name               = module.label.id
  capacity_providers = ["FARGATE", "FARGATE_SPOT"]
  default_capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    base              = 1
    weight            = 1
  }
  tags = module.label.tags
}

resource aws_ecs_service this {
  name = module.label.id
  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    base              = 1
    weight            = 1
  }
  cluster = aws_ecs_cluster.this.id
  deployment_controller {
    type = var.deployment_contoller_type
  }
  deployment_maximum_percent         = var.deployment_maximum_percent
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent
  desired_count                      = var.desired_count
  enable_ecs_managed_tags            = true
  # launch_type                        = "FARGATE"
  dynamic load_balancers {
    for_each = var.load_balancer
    content {
      target_group_arn = load_balancer.value.target_group_arn
      container_name   = load_balancer.value.container_name
      container_port   = load_balancer.value.container_port
    }
  }
  network_configuration {
    subnets          = var.network_configuration.subnets
    security_groups  = var.network_configuration.security_groups
    assign_public_ip = var.network_configuration.assign_public_ip
  }
  task_definition = "${data.aws_ecs_task_definition.this.family}:${data.aws_ecs_task_definition.this.revision}"
  tags            = module.tags
  depends_on = [
    aws_ecs_cluster.this,
    aws_iam_role.this,
    data.aws_ecs_task_definition.this,
  ]
  lifecycle {
    ignore_changes = [
      desired_count,
    ]
  }
}

# resource aws_iam_role this {
#   name            = module.label.id
#   path                  = var.iam_path
#   force_detach_policies = true
#   assume_role_policy    = <<EOF
# {
#   "Version": "2008-10-17",
#   "Statement": [
#     {
#       "Sid": "",
#       "Effect": "Allow",
#       "Principal": {
#         "Service": "ecs.amazonaws.com"
#       },
#       "Action": "sts:AssumeRole"
#     }
#   ]
# }
# EOF
# }
#
# resource aws_iam_role_policy" "ecs_service" {
#   name   = "${var.name}-ecs-service-policy"
#   role   = aws_iam_role.ecs_service[0].name
#   policy = var.iam_role_inline_policy
# }
