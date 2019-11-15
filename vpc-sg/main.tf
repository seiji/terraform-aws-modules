resource "aws_security_group" "this" {
  name    = "${var.service}-${var.env}-${var.name}"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${var.service}-${var.env}-${var.name}"
    service = "${var.service}"
    env     = "${var.env}"
  }
}

resource "aws_security_group_rule" "this" {
  security_group_id = "${aws_security_group.this.id}"

  type = "ingress"

  from_port = var.from_port
  to_port   = var.to_port
  protocol  = var.protocol
  cidr_blocks = var.cidr_blocks
}
