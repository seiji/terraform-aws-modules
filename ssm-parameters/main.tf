resource "aws_ssm_parameter" "this" {
  for_each = var.parameters

  name  = "/${var.namespace}/${var.stage}/${each.key}"
  type  = each.value.type
  value = each.value.value

  tags = {
    "namespace" = var.namespace
    "stage"     = var.stage
  }
}
