resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = module.label.tags
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = module.label.tags
}

