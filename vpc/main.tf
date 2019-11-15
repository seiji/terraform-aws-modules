module "label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=master"
  namespace  = var.namespace
  stage      = var.stage
  name       = "${var.namespace}-${var.stage}"
  attributes = ["private"]

  tags = {
    "BusinessUnit" = "Development",
  }
}
