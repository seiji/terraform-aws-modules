module "label" {
  source    = "git::https://github.com/cloudposse/terraform-null-label.git?ref=master"
  namespace = var.namespace
  stage     = var.stage

  additional_tag_map = {
    propagate_at_launch = "true"
  }
}
