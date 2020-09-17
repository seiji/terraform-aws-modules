module label {
  source     = "../label"
  service    = var.service
  env        = var.env
  attributes = var.attributes
  name       = var.name
  add_tags   = var.add_tags
}

resource aws_codepipeline this {
  name     = module.label.id
  role_arn = var.role_arn

  dynamic artifact_store {
    for_each = var.artifact_store
    content {
      location = artifact_store.value.location
      type     = artifact_store.value.type
    }
  }

  dynamic stage {
    for_each = var.stage
    content {
      name = stage.value.name
      dynamic action {
        for_each = [stage.value.action]
        content {
          category         = action.value.category
          configuration    = action.value.configuration
          input_artifacts  = action.value.input_artifacts
          name             = action.value.name
          namespace        = action.value.namespace
          output_artifacts = action.value.output_artifacts
          owner            = action.value.owner
          provider         = action.value.provider
          region           = action.value.region
          role_arn         = action.value.role_arn
          run_order        = action.value.run_order
          version          = action.value.version
        }
      }
    }
  }
  tags = module.label.tags
}
