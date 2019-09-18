# ALB
# https://www.terraform.io/docs/providers/aws/d/lb.html
resource "aws_lb" "this" {
  load_balancer_type = "application"
  name        = "${var.service}-lb"

  security_groups = ["${aws_security_group.alb.id}"]
  subnets         = ["${aws_subnet.public_1a.id}", "${aws_subnet.public_1c.id}", "${aws_subnet.public_1d.id}"]
}

resource "aws_lb_target_group" "this" {
  name        = "${var.service}-tg"

  vpc_id = "${var.vpc_id}"

  port        = 80
  protocol    = "HTTP"
  target_type = "ip"

  health_check = {
    port = 80
    path = "/"
  }
}

resource "aws_lb_listener_rule" "this" {
  listener_arn = "${aws_lb_listener.this.arn}"

  action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.this.id}"
  }

  condition {
    field  = "path-pattern"
    values = ["*"]
  }
}
