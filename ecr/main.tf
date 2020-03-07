module label {
  source    = "../label"
  namespace = var.namespace
  stage     = var.stage
}

resource aws_ecr_repository this {
  for_each             = { for r in var.repositories : r.name => r }
  name                 = each.value.name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = module.label.tags
}

resource aws_ecr_lifecycle_policy this {
  for_each   = { for r in var.repositories : r.name => r if r.lifecycle_policy_json != null }
  repository = each.value.name

  policy = each.value.lifecycle_policy_json

  depends_on = [aws_ecr_repository.this]
}
