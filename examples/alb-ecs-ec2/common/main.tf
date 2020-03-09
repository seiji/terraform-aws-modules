locals {
  namespace = "alb-ecs-ec2"
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
      name                  = "alb-ecs-ec2-nginx"
      lifecycle_policy_json = null
    },
    {
      name                  = "alb-ecs-ec2-node"
      lifecycle_policy_json = null
    },
  ]
}

