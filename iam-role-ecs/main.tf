terraform {
  required_version = ">= 0.12.0"
}

data "aws_iam_policy_document" "ecs_tasks_service" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_task_execution" {
  name               = var.iam_role_name_ecs_task_execution
  assume_role_policy = data.aws_iam_policy_document.ecs_tasks_service.json
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = aws_iam_role.ecs_task_execution.id
}

resource "aws_iam_role_policy_attachment" "ssm_ro" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
  role       = aws_iam_role.ecs_task_execution.id
}

data "aws_iam_policy_document" "ecs_service" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_service" {
  name               = var.iam_role_name_ecs_service
  assume_role_policy = data.aws_iam_policy_document.ecs_service.json
}

resource "aws_iam_role_policy_attachment" "ec2_container_service" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
  role       = aws_iam_role.ecs_service.id
}

data "aws_iam_policy_document" "ec2_service" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_instance" {
  name               = var.iam_role_name_ecs_instance
  assume_role_policy = data.aws_iam_policy_document.ec2_service.json
}

resource "aws_iam_role_policy_attachment" "ec2_container_service_ec2" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
  role       = aws_iam_role.ecs_instance.id
}

resource "aws_iam_instance_profile" "ecs_instance" {
  name = var.iam_role_name_ecs_instance
  role = aws_iam_role.ecs_instance.id
}
