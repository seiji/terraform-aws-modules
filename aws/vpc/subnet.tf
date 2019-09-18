resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name    = "public-${var.service}-${var.env}"
  }
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route" "private" {
  route_table_id         = aws_vpc.this.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this.id
}

resource "aws_subnet" "public" {
  count             = length(var.azs)
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.public_subnets[count.index]
  availability_zone = var.azs[count.index]

  lifecycle {
    ignore_changes = ["tags"]
  }

  tags = {
    Name    = "vpc-subnet-public-${var.azs[count.index]}-${var.service}-${var.env}"
    service = var.service
    env     = var.env
  }
}

resource "aws_subnet" "private" {
  count             = length(var.azs)
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = var.azs[count.index]

  lifecycle {
    ignore_changes = ["tags"]
  }

  tags = {
    Name    = "vpc-subnet-private-${var.azs[count.index]}-${var.service}-${var.env}"
    service = var.service
    env     = var.env
  }
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public.*.id)
  route_table_id = aws_route_table.public.id
  subnet_id      = element(aws_subnet.public.*.id, count.index)
}

resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private.*.id)
  route_table_id = aws_vpc.this.main_route_table_id
  subnet_id      = element(aws_subnet.private.*.id, count.index)
}

