output control_arn {
  value = module.iam_role_eks_control.arn
}

output control_name {
  value = module.iam_role_eks_control.name
}

output node_arn {
  value = module.iam_role_eks_node.arn
}

output node_name {
  value = module.iam_role_eks_node.name
}
