locals {
  instance_type = "t3.nano"
}

data "aws_ami" "recent_amzn_vpc_nat" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-vpc-nat-hvm-*-x86_64-ebs"]
  }
  filter {
    name   = "state"
    values = ["available"]
  }
}

resource "aws_eip" "nat" {
  vpc        = true
  depends_on = [aws_internet_gateway.this]
}

resource "aws_nat_gateway" "this" {
  count         = var.use_natgw ? 1 : 0
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[count.index].id
  depends_on    = [aws_internet_gateway.this, aws_subnet.public]

  tags = module.label.tags
}

resource "aws_instance" "nati" {
  count                  = var.use_natgw ? 0 : 1
  ami                    = data.aws_ami.recent_amzn_vpc_nat.image_id
  instance_type          = local.instance_type
  subnet_id              = aws_subnet.public[count.index].id
  vpc_security_group_ids = [aws_vpc.this.default_security_group_id]
  source_dest_check      = false

  tags = module.label.tags
}

resource "aws_eip_association" "nati" {
  count         = var.use_natgw ? 0 : 1
  instance_id   = aws_instance.nati[count.index].id
  allocation_id = aws_eip.nat.id
}
