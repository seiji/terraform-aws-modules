data aws_iam_policy ecs_task_execution {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data aws_iam_policy_document ecs_task_execution {
  source_json = data.aws_iam_policy.ecs_task_execution.policy
}

data aws_iam_policy ssm_read_only {
  arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
}

data aws_iam_policy_document ssm_read_only {
  source_json = data.aws_iam_policy.ssm_read_only.policy
}

data aws_iam_policy cwa_server {
  arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

data aws_iam_policy_document cwa_server {
  source_json = data.aws_iam_policy.cwa_server.policy
}

module iam_role_ecs_task_execution {
  source     = "../iam-role"
  name       = var.iam_role_name_ecs_task_execution
  identifier = "ecs-tasks.amazonaws.com"
  policies = [
    data.aws_iam_policy_document.ecs_task_execution.json,
    data.aws_iam_policy_document.ssm_read_only.json,
    data.aws_iam_policy_document.cwa_server.json,
  ]
}

data aws_iam_policy ec2_container {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

data aws_iam_policy_document ec2_container {
  source_json = data.aws_iam_policy.ec2_container.policy
}

module iam_role_ecs_service {
  source     = "../iam-role"
  name       = var.iam_role_name_ecs_service
  identifier = "ecs.amazonaws.com"
  policies = [
    data.aws_iam_policy_document.ec2_container.json,
  ]
}

data aws_iam_policy ec2_container_ec2 {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

data aws_iam_policy_document ec2_container_ec2 {
  source_json = data.aws_iam_policy.ec2_container_ec2.policy
}

module iam_role_ecs_instance {
  source     = "../iam-role"
  name       = var.iam_role_name_ecs_instance
  identifier = "ec2.amazonaws.com"
  policies = [
    data.aws_iam_policy_document.ec2_container_ec2.json,
  ]
}

resource aws_iam_instance_profile this {
  name = var.iam_role_name_ecs_instance
  role = module.iam_role_ecs_instance.id
}
