module "label" {
  source     = "../../label"
  service    = var.service
  env        = var.env
  attributes = var.attributes
  name       = var.name
}

resource "aws_eip" "this" {
  vpc  = true
  tags = module.label.tags
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.this.id
  subnet_id     = var.subnet_id
  depends_on    = [aws_eip.this]
  tags          = module.label.tags
}
