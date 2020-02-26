module iam_role_eks_control {
  source     = "../iam-role"
  name       = var.control_name
  identifier = "eks.amazonaws.com"
  policy_arns = [
    data.aws_iam_policy.eks_cluster_policy.arn,
    data.aws_iam_policy.eks_service_policy.arn,
  ]
}

module iam_role_eks_node {
  source     = "../iam-role"
  name       = var.node_name
  identifier = "ec2.amazonaws.com"
  policy_arns = [
    data.aws_iam_policy.eks_worker_node_policy.arn,
    data.aws_iam_policy.eks_cni_policy.arn,
    data.aws_iam_policy.ec2_container_registry_readonly.arn,
  ]
}
