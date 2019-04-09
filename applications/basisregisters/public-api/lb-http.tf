resource "aws_lb_listener" "http" {
  load_balancer_arn = "${aws_lb.main.id}"
  port              = "${var.lb_port}"
  protocol          = "${var.lb_protocol}"

  default_action {
    target_group_arn = "${aws_lb_target_group.main.id}"
    type             = "forward"
  }
}

# Incoming HTTP
resource "aws_security_group_rule" "ingress_http" {
  type = "ingress"

  from_port   = "${var.lb_port}"
  to_port     = "${var.lb_port}"
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  description = "Public Api Load Balancer (${var.lb_protocol})"

  security_group_id = "${aws_security_group.main-lb.id}"
}
