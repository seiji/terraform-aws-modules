module "label" {
  source    = "../label"
  namespace = var.namespace
  stage     = var.stage
}

module "iam_role_eks" {
  source = "../iam-role-eks"
}

resource "aws_eks_cluster" "this" {
  name     = module.label.id
  role_arn = module.iam_role_eks.control_arn

  version = var.cluster_version

  vpc_config {
    endpoint_public_access = var.vpc_config.endpoint_public_access
    security_group_ids     = var.vpc_config.security_group_ids
    subnet_ids             = var.vpc_config.subnet_ids
  }

  depends_on = [
    module.iam_role_eks,
  ]

  tags = module.label.tags
}

