module label {
  source    = "../label"
  namespace = var.namespace
  stage     = var.stage
}

locals {
  domain_name = module.label.id
}

data aws_caller_identity this {}

resource aws_iam_service_linked_role this {
  aws_service_name = "es.amazonaws.com"
  provisioner local-exec {
    command = "sleep 10"
  }
}

resource aws_elasticsearch_domain this {
  domain_name           = local.domain_name
  elasticsearch_version = var.elasticsearch_version

  dynamic vpc_options {
    for_each = [for op in var.vpc_options.enabled ? [var.vpc_options] : [] : op]
    content {
      subnet_ids         = vpc_options.value.subnet_ids
      security_group_ids = vpc_options.value.security_group_ids
    }
  }
  dynamic cluster_config {
    for_each = [var.cluster_config]
    content {
      instance_type            = cluster_config.value.instance_type
      instance_count           = cluster_config.value.instance_count
      dedicated_master_enabled = cluster_config.value.dedicated_master_enabled
      zone_awareness_enabled   = cluster_config.value.availability_zone_count > 1 ? true : false

      dynamic zone_awareness_config {
        for_each = cluster_config.value.availability_zone_count > 1 ? [true] : []
        content {
          availability_zone_count = cluster_config.value.availability_zone_count
        }
      }
    }
  }
  ebs_options {
    ebs_enabled = var.ebs_options.ebs_enabled
    volume_type = var.ebs_options.volume_type
    volume_size = var.ebs_options.volume_size
  }
  encrypt_at_rest {
    enabled    = var.encrypt_at_rest
    kms_key_id = var.kms_key_id
  }
  node_to_node_encryption {
    enabled = var.node_to_node_encryption
  }
  snapshot_options {
    automated_snapshot_start_hour = var.automated_snapshot_start_hour
  }
  dynamic cognito_options {
    for_each = [for op in var.cognito_options.enabled ? [var.cognito_options] : [] : op]
    content {
      enabled          = cognito_options.value.enabled
      user_pool_id     = cognito_options.value.user_pool_id
      identity_pool_id = cognito_options.value.identity_pool_id
      role_arn         = cognito_options.value.role_arn
    }
  }
  advanced_options = {
    "rest.action.multi.allow_explicit_index" = "true"
  }

  depends_on = [
    aws_iam_service_linked_role.this,
  ]
  lifecycle {
    ignore_changes = [log_publishing_options]
  }
  tags = module.label.tags
}

resource aws_elasticsearch_domain_policy cognito {
  count       = var.cognito_options.enabled ? 1 : 0
  domain_name = aws_elasticsearch_domain.this.domain_name

  access_policies = <<POLICIES
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS":"arn:aws:sts::${data.aws_caller_identity.this.account_id}:assumed-role/${var.cognito_options.auth_role_name}/CognitoIdentityCredentials"
      },
      "Action": [
        "es:*"
      ],
      "Resource": "${aws_elasticsearch_domain.this.arn}/*"
    }
  ]
}
POLICIES
  depends_on = [
    aws_elasticsearch_domain.this,
  ]
}

locals {
  allowed_ips = ["aa", "bbb"]
}
resource aws_elasticsearch_domain_policy allowed_ip {
  count       = length(var.allowed_ips) > 0 ? 1 : 0
  domain_name = aws_elasticsearch_domain.this.domain_name

  access_policies = <<POLICIES
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS":"*"
      },
      "Action": [
        "es:*"
      ],
      "Resource": "${aws_elasticsearch_domain.this.arn}/*",
      "Condition": {
        "IpAddress": {
          "aws:SourceIp": ${jsonencode(var.allowed_ips)}
        }
      }
    }
  ]
}
POLICIES
  depends_on = [
    aws_elasticsearch_domain.this,
  ]
}
