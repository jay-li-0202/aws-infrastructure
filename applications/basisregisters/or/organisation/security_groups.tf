resource "aws_security_group" "api-lb" {
  name        = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-organisation-lb"
  description = "Security group for Organisation Load Balancer"
  vpc_id      = var.vpc_id

  tags = {
    Name        = "Organisation Load Balancer // ${var.environment_label} ${var.environment_name}"
    Environment = var.tag_environment
    Productcode = var.tag_product
    Programma   = var.tag_program
    Contact     = var.tag_contact
  }
}

resource "aws_security_group_rule" "lb_egress_rule" {
  description              = "Organisation Load Balancer To Task on port ${var.port_range}-${var.port_range + 7}"
  type                     = "egress"
  from_port                = var.port_range
  to_port                  = var.port_range + 7
  protocol                 = "tcp"
  source_security_group_id = var.ecs_sg_id
  security_group_id        = aws_security_group.api-lb.id
}

resource "aws_security_group_rule" "task_ingress_rule" {
  description              = "Organisation Load Balancer To Task on port ${var.port_range}-${var.port_range + 7}"
  type                     = "ingress"
  from_port                = var.port_range
  to_port                  = var.port_range + 7
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.api-lb.id
  security_group_id        = var.ecs_sg_id
}

resource "aws_security_group_rule" "organisation" {
  description       = "Organisation Registry"
  type              = "ingress"
  from_port         = var.port_range
  to_port           = var.port_range + 7
  protocol          = "tcp"
  security_group_id = var.task_security_group_id
  self              = true
}
