terraform {
  required_version = ">= 0.12.0"
}

provider "aws" {
  version = "~> 2.22"
  region  = var.region
}

resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  lifecycle {
    ignore_changes = [
      "tags"
    ]
  }
  tags = {
    Name    = "vpc-${var.service}-${var.env}"
    service = var.service
    env     = var.env
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
}

resource "aws_eip" "this" {
  vpc        = true
  depends_on = [aws_internet_gateway.this]
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.this.id
  subnet_id     = aws_subnet.public[0].id
  depends_on    = [aws_internet_gateway.this, aws_subnet.public]
  tags = {
    Name    = "vpc-natgw-${var.service}-${var.env}"
  }
}
