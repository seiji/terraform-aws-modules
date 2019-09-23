resource "aws_eip" "nat" {
  vpc        = true
  depends_on = [aws_internet_gateway.this]
}

resource "aws_nat_gateway" "this" {
  count = var.use_natgw ? lenght(var.nat_subnet_id_list) : 0
  allocation_id = aws_eip.nat.id
  subnet_id     = var.nat_subnet_id_list[count.index]
  depends_on    = [aws_internet_gateway.this, aws_subnet.public]

  tags = module.label.tags
}
