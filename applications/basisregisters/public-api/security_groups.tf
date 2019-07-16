resource "aws_security_group" "main-lb" {
  name        = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-public-api-lb"
  description = "Security group for Public Api Balancer"
  vpc_id      = "${var.vpc_id}"

  tags = {
    Name        = "Public Api Load Balancer // ${var.environment_label} ${var.environment_name}"
    Environment = "${var.tag_environment}"
    Productcode = "${var.tag_product}"
    Programma   = "${var.tag_program}"
    Contact     = "${var.tag_contact}"
  }
}

// TODO: Set to fixed ip of API gateway, or use authentication on load balancer
resource "aws_security_group_rule" "lb_egress_rule" {
  description              = "Public Load Balancer To Task on port ${var.container_port}"
  type                     = "egress"
  from_port                = "${var.container_port}"
  to_port                  = "${var.container_port}"
  protocol                 = "tcp"
  source_security_group_id = "${var.ecs_sg_id}"
  security_group_id        = "${aws_security_group.main-lb.id}"
}

resource "aws_security_group_rule" "task_ingress_rule" {
  description              = "Public Load Balancer To Task on port ${var.container_port}"
  type                     = "ingress"
  from_port                = "${var.container_port}"
  to_port                  = "${var.container_port}"
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.main-lb.id}"
  security_group_id        = "${var.ecs_sg_id}"
}
