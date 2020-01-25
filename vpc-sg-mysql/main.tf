module vpc_sg {
  source      = "../vpc-sg"
  namespace   = var.namespace
  stage       = var.stage
  attributes  = ["mysql"]
  vpc_id      = var.vpc_id
  from_port   = 3306
  to_port     = 3306
  protocol    = "tcp"
  cidr_blocks = var.cidr_blocks
}

