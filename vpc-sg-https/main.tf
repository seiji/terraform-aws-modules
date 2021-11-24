module "label" {
  source     = "../label"
  namespace  = var.namespace
  stage      = var.stage
  attributes = concat(["https"], var.attributes)
}

resource "aws_security_group" "this" {
  name   = module.label.id
  vpc_id = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = module.label.tags
}

resource "aws_security_group_rule" "http" {
  security_group_id = aws_security_group.this.id

  type = "ingress"

  protocol    = "tcp"
  from_port   = 80
  to_port     = 80
  cidr_blocks = var.cidr_blocks
}

resource "aws_security_group_rule" "https" {
  security_group_id = aws_security_group.this.id
  type              = "ingress"

  protocol    = "tcp"
  from_port   = 443
  to_port     = 443
  cidr_blocks = var.cidr_blocks
}
