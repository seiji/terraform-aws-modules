locals {
  namespace = "alb-ecs-fargate"
  stage     = "common"
}

module iam_role_ecs {
  source = "../../../iam-role-ecs"
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

