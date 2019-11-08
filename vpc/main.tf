terraform {
  required_version = "~> 0.12.0"
}

provider "aws" {
  version = "~> 2.22"
  region  = var.region
}

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
