module label {
  source    = "git::https://github.com/cloudposse/terraform-null-label.git?ref=master"
  namespace = var.namespace
  stage     = var.stage
}

resource aws_iam_service_linked_role this {
  aws_service_name = "es.amazonaws.com"
}

resource aws_elasticsearch_domain this {
  domain_name           = module.label.id
  elasticsearch_version = var.elasticsearch_version
  vpc_options {
    subnet_ids         = var.subnet_ids
    security_group_ids = var.security_group_ids
  }
  cluster_config {
    instance_type  = var.instance_type
    instance_count = var.instance_count
    # dedicated_master_enabled = false
    zone_awareness_enabled = true
    zone_awareness_config {
      availability_zone_count = length(var.subnet_ids)
    }
  }
  ebs_options {
    ebs_enabled = true
    volume_type = var.volume_type
    volume_size = var.volume_size
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
  cognito_options {
    enabled = true
    # user_pool_id
    # identity_pool_id
    # role_arn
  }
  advanced_options = {
    "rest.action.multi.allow_explicit_index" = "true"
  }

  tags = module.label.tags

  depends_on = [
    aws_iam_service_linked_role.this,
  ]
}
#
# resource aws_elasticsearch_domain_policy this {
#   domain_name = aws_elasticsearch_domain.this.domain_name
#
#   access_policies = <<POLICIES
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": "es:*",
#       "Principal": "*",
#       "Effect": "Allow",
#       "Condition": {
#         "IpAddress": {"aws:SourceIp": "103.5.140.172/32"}
#       },
#       "Resource": "${aws_elasticsearch_domain.this.arn}/*"
#     }
#   ]
# }
# POLICIES
# }
