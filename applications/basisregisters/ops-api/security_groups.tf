# Incoming HTTP
resource "aws_security_group_rule" "ingress_http" {
  count = "${length(var.admin_cidr_blocks)}"
  type  = "ingress"

  from_port   = "0"
  to_port     = "65535"
  protocol    = "tcp"
  cidr_blocks = ["${element(split("|", element(var.admin_cidr_blocks, count.index)), 0)}"]
  description = "Ops Api Load Balancer (${element(split("|", element(var.admin_cidr_blocks, count.index)), 1)})"

  security_group_id = "${aws_security_group.main-lb.id}"
}

resource "aws_security_group" "main-lb" {
  name        = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-ops-api-lb"
  description = "Security group for Ops Api Balancer"
  vpc_id      = "${var.vpc_id}"

  tags {
    Name        = "Ops Api Load Balancer // ${var.environment_label} ${var.environment_name}"
    Environment = "${var.tag_environment}"
    Productcode = "${var.tag_product}"
    Programma   = "${var.tag_program}"
    Contact     = "${var.tag_contact}"
  }
}

resource "aws_security_group_rule" "lb_egress_rule" {
  count = "${length(var.container_ports)}"

  description              = "Ops Load Balancer To Task on port ${element(var.container_ports, count.index)}"
  type                     = "egress"
  from_port                = "${element(split("-", element(var.container_ports, count.index)), 0)}"
  to_port                  = "${element(split("-", element(var.container_ports, count.index)), 1)}"
  protocol                 = "tcp"
  source_security_group_id = "${var.ecs_sg_id}"
  security_group_id        = "${aws_security_group.main-lb.id}"
}

resource "aws_security_group_rule" "task_ingress_rule" {
  count = "${length(var.container_ports)}"

  description              = "Ops Load Balancer To Task on port ${element(var.container_ports, count.index)}"
  type                     = "ingress"
  from_port                = "${element(split("-", element(var.container_ports, count.index)), 0)}"
  to_port                  = "${element(split("-", element(var.container_ports, count.index)), 1)}"
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.main-lb.id}"
  security_group_id        = "${var.ecs_sg_id}"
}
