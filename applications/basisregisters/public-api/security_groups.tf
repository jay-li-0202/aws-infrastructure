resource "aws_security_group" "main-lb" {
  name        = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-lb"
  description = "Security group for Public Api Balancer"
  vpc_id      = "${var.vpc_id}"

  tags {
    Name        = "Public Api Load Balancer // ${var.environment_label} ${var.environment_name}"
    Environment = "${var.tag_environment}"
    Productcode = "${var.tag_product}"
    Programma   = "${var.tag_program}"
    Contact     = "${var.tag_contact}"
  }
}

resource "aws_security_group" "task" {
  name        = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-task"
  description = "Security group for ECS Task"
  vpc_id      = "${var.vpc_id}"

  tags {
    Name        = "ECS Task // ${var.environment_label} ${var.environment_name}"
    Environment = "${var.tag_environment}"
    Productcode = "${var.tag_product}"
    Programma   = "${var.tag_program}"
    Contact     = "${var.tag_contact}"
  }
}

resource "aws_security_group_rule" "lb_egress_rule" {
  description              = "Load Balancer To Task on port ${var.container_port}"
  type                     = "egress"
  from_port                = "${var.container_port}"
  to_port                  = "${var.container_port}"
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.task.id}"
  security_group_id        = "${aws_security_group.main-lb.id}"
}

resource "aws_security_group_rule" "task_ingress_rule" {
  description              = "Load Balancer To Task on port ${var.container_port}"
  type                     = "ingress"
  from_port                = "${var.container_port}"
  to_port                  = "${var.container_port}"
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.main-lb.id}"
  security_group_id        = "${aws_security_group.task.id}"
}

resource "aws_security_group_rule" "task_egress_rule" {
  description = "Task outgoing"
  type        = "egress"
  from_port   = "0"
  to_port     = "0"
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.task.id}"
}