module label {
  source    = "../label"
  service = var.service
  env     = var.env
  name    = var.name
}

resource aws_ecr_repository this {
  name                 = module.label.id
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
  tags = module.label.tags
}

resource aws_ecr_lifecycle_policy this {
  count      = var.lifecycle_policy_json != null ? 1 : 0
  repository = aws_ecr_repository.this.name
  policy     = var.lifecycle_policy_json
  depends_on = [aws_ecr_repository.this]
}
