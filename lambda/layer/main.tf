module label {
  source    = "../../label"
  namespace = var.namespace
  stage     = var.stage
}

resource aws_lambda_layer_version this {
  layer_name       = module.label.id
  filename         = var.filename
  source_code_hash = var.source_code_hash
}
