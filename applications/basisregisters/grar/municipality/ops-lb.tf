resource "aws_lb_target_group" "import" {
  name                 = "municipality-import"
  port                 = "${var.port_range}"
  protocol             = "HTTP"
  vpc_id               = "${var.vpc_id}"
  target_type          = "ip"
  deregistration_delay = "${var.deregistration_delay}"

  tags {
    Name        = "Municipality Import // ${var.environment_label} ${var.environment_name}"
    Environment = "${var.tag_environment}"
    Productcode = "${var.tag_product}"
    Programma   = "${var.tag_program}"
    Contact     = "${var.tag_contact}"
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = "${var.ops_lb_arn}"
  port              = "${var.port_range}"
  protocol          = "HTTPS"
  certificate_arn   = "${var.ops_cert_arn}"

  default_action {
    target_group_arn = "${aws_lb_target_group.import.id}"
    type             = "forward"
  }
}
