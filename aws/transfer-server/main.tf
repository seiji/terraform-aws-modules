module "label" {
  source     = "../../label"
  service    = var.service
  env        = var.env
  name       = var.name
  attributes = var.attributes
  add_tags   = var.add_tags
}

data "aws_iam_role" "loggin_access" {
  name = "AWSTransferLoggingAccess"
}

resource "aws_transfer_server" "this" {
  domain               = var.domain
  protocols            = ["SFTP"]
  endpoint_type        = "VPC"
  logging_role         = data.aws_iam_role.loggin_access.arn
  security_policy_name = "TransferSecurityPolicy-2020-06"

  dynamic "endpoint_details" {
    for_each = var.endpoint_details != null ? [var.endpoint_details] : []
    content {
      subnet_ids         = endpoint_details.value.subnet_ids
      vpc_id             = endpoint_details.value.vpc_id
      security_group_ids = endpoint_details.value.security_group_ids
    }
  }
  tags = module.label.tags
}

resource "aws_transfer_user" "this" {
  for_each            = { for u in var.users : u.name => u }
  server_id           = aws_transfer_server.this.id
  user_name           = each.value.name
  role                = each.value.role
  home_directory_type = "LOGICAL"
  dynamic "home_directory_mappings" {
    for_each = [true]
    content {
      entry  = each.value.entry
      target = each.value.target
    }
  }
  dynamic "posix_profile" {
    for_each = each.value.posix_profile != null ? [each.value.posix_profile] : []
    content {
      gid            = posix_profile.value.gid
      secondary_gids = posix_profile.value.secondary_gids
      uid            = posix_profile.value.uid
    }
  }
}
