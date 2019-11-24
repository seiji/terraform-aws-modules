resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
  tags = module.label.tags
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = module.label.tags
}

