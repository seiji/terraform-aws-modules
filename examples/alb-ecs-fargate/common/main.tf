locals {
  namespace = "alb-ecs-fargate"
  stage     = "common"
}

module iam_role_ecs {
  source = "../../../iam-role-ecs"
}

data aws_iam_policy_document allow_s3 {
  statement {
    effect = "Allow"
    actions = [
      "s3:Get*",
      "s3:List*"
    ]
    resources = [
      "arn:aws:s3:::data.seiji.me",
      "arn:aws:s3:::data.seiji.me/*",
    ]
  }
}

module iam_role_ecs_tasks {
  source = "../../../iam-role"
  name   = join("-", [local.namespace, local.stage, "ecs-tasks"])

  principals = {
    type        = "Service"
    identifiers = ["ecs-tasks.amazonaws.com"]
  }
  policy_json_list = [data.aws_iam_policy_document.allow_s3.json]
}

module ecr_repos {
  source    = "../../../ecr"
  namespace = local.namespace
  stage     = local.stage
  repositories = [
    {
      name                  = "alb-ecs-fargate-nginx"
      lifecycle_policy_json = null
    },
    {
      name                  = "alb-ecs-fargate-node"
      lifecycle_policy_json = null
    },
  ]
}

