module "iam_role_ecs_task_execution" {
  source = "../iam-role"
  name   = var.iam_role_name_ecs_task_execution
  principals = {
    type        = "Service"
    identifiers = ["ecs-tasks.amazonaws.com"]
  }
  policy_json_list = [
    data.aws_iam_policy_document.ecs_task_execution.json,
    data.aws_iam_policy_document.ssm_read_only.json,
    data.aws_iam_policy_document.cwa_server.json,
  ]
}

module "iam_role_ecs_service" {
  source = "../iam-role"
  name   = var.iam_role_name_ecs_service
  principals = {
    type        = "Service"
    identifiers = ["ecs.amazonaws.com"]
  }
  policy_json_list = [
    data.aws_iam_policy_document.ec2_container.json,
  ]
}

module "iam_role_ecs_instance" {
  source = "../iam-role"
  name   = var.iam_role_name_ecs_instance
  principals = {
    type        = "Service"
    identifiers = ["ec2.amazonaws.com"]
  }
  policy_json_list = [
    data.aws_iam_policy_document.ec2_container_ec2.json,
    data.aws_iam_policy_document.ec2_for_ssm.json,
  ]
}

resource "aws_iam_instance_profile" "this" {
  name = var.iam_role_name_ecs_instance
  role = module.iam_role_ecs_instance.id
}
