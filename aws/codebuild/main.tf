module "label" {
  source     = "../../label"
  service    = var.service
  env        = var.env
  attributes = var.attributes
  name       = var.name
  add_tags   = var.add_tags
}

resource "aws_codebuild_project" "this" {
  name           = module.label.id
  badge_enabled  = var.badge_enabled
  build_timeout  = var.build_timeout
  description    = var.description
  queued_timeout = 480
  service_role   = var.service_role
  source_version = var.source_version
  dynamic "artifacts" {
    for_each = var.artifacts
    content {
      type                   = artifacts.value.type
      artifact_identifier    = artifacts.value.artifact_identifier
      encryption_disabled    = artifacts.value.encryption_disabled
      override_artifact_name = artifacts.value.override_artifact_name
      location               = artifacts.value.location
      name                   = artifacts.value.name
      namespace_type         = artifacts.value.namespace_type
      packaging              = artifacts.value.packaging
      path                   = artifacts.value.path
    }
  }

  dynamic "cache" {
    for_each = var.cache != null ? [var.cache] : []
    content {
      type     = cache.value.type
      location = cache.value.location
      modes    = cache.value.modes
    }
  }

  dynamic "environment" {
    for_each = [var.environment]
    content {
      certificate  = environment.value.certificate
      compute_type = environment.value.compute_type
      dynamic "environment_variable" {
        for_each = environment.value.environment_variable
        content {
          name  = environment_variable.value.name
          value = environment_variable.value.value
          type  = environment_variable.value.type
        }
      }
      image                       = environment.value.image
      image_pull_credentials_type = environment.value.image_pull_credentials_type
      privileged_mode             = environment.value.privileged_mode
      dynamic "registry_credential" {
        for_each = environment.value.registry_credential != null ? [environment.value.registry_credential] : []
        content {
          credential          = registry_credential.value.credential
          credential_provider = registry_credential.value.credential_provider
        }
      }
      type = environment.value.type
    }
  }

  dynamic "logs_config" {
    for_each = var.logs_config != null ? [var.logs_config] : []
    content {
      dynamic "cloudwatch_logs" {
        for_each = logs_config.value.cloudwatch_logs != null ? [logs_config.value.cloudwatch_logs] : []
        content {
          status      = cloudwatch_logs.value.status
          group_name  = cloudwatch_logs.value.group_name
          stream_name = cloudwatch_logs.value.stream_name
        }
      }
      dynamic "s3_logs" {
        for_each = logs_config.value.s3_logs != null ? [logs_config.value.s3_logs] : []
        content {
          status   = s3_logs.value.status
          location = s3_logs.value.location
        }
      }
    }
  }

  dynamic "source" {
    for_each = var.sources
    content {
      type = source.value.type
      dynamic "auth" {
        for_each = source.value.auth != null ? [source.value.auth] : []
        content {
          type     = auth.value.type
          resource = auth.value.resource
        }
      }
      buildspec       = source.value.buildspec
      git_clone_depth = source.value.git_clone_depth

      dynamic "git_submodules_config" {
        for_each = source.value.git_submodules_config != null ? [source.value.git_submodules_config] : []
        content {
          fetch_submodules = git_submodules_config.value.fetch_submodules
        }
      }
      insecure_ssl        = source.value.insecure_ssl
      location            = source.value.location
      report_build_status = source.value.report_build_status
    }
  }

  tags = module.label.tags
}

resource "aws_codebuild_webhook" "this" {
  count        = var.webhook != null ? 1 : 0
  project_name = aws_codebuild_project.this.name
  dynamic "filter_group" {
    for_each = var.webhook.filter_group != null ? var.webhook.filter_group : []
    content {
      dynamic "filter" {
        for_each = filter_group.value.filter
        content {
          type    = filter.value.type
          pattern = filter.value.pattern
        }
      }
    }
  }
  depends_on = [aws_codebuild_webhook.this]
}
