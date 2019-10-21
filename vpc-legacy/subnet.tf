resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.this.id}"

  tags = {
    Name = "public-${var.namespace}-${var.stage}"
  }
}

resource "aws_route" "public" {
  route_table_id         = "${aws_route_table.public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.this.id}"
}

resource "aws_subnet" "public" {
  vpc_id            = "${aws_vpc.this.id}"
  cidr_block        = "${var.public_subnets[0]}"
  availability_zone = "${var.azs[0]}"

  lifecycle {
    ignore_changes = ["tags"]
  }

  tags = {
    Name      = "vpc-subnet-public-${var.azs[count.index]}-${var.namespace}-${var.stage}"
    namespace = "${var.namespace}"
    stage     = "${var.stage}"
    Tier      = "Public"
  }
}

resource "aws_route_table_association" "public" {
  route_table_id = "${aws_route_table.public.id}"
  subnet_id      = "${aws_subnet.public.id}"
}
