resource "aws_lb_listener" "https" {
  load_balancer_arn = "${aws_lb.main.id}"
  port              = "${var.lb_https_port}"
  protocol          = "HTTPS"
  certificate_arn   = "${aws_acm_certificate.main.arn}"

  default_action {
    target_group_arn = "${aws_lb_target_group.main.id}"
    type             = "forward"
  }
}

# Incoming HTTPS
resource "aws_security_group_rule" "ingress_https" {
  type = "ingress"

  from_port   = "${var.lb_https_port}"
  to_port     = "${var.lb_https_port}"
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  description = "Public Api Load Balancer (HTTPS)"

  security_group_id = "${aws_security_group.main-lb.id}"
}
