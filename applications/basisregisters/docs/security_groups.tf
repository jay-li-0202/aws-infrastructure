resource "aws_security_group" "docs-lb" {
  name        = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-docs-lb"
  description = "Security group for Docs Balancer"
  vpc_id      = var.vpc_id

  tags = {
    Name        = "Docs Load Balancer // ${var.environment_label} ${var.environment_name}"
    Environment = var.tag_environment
    Productcode = var.tag_product
    Programma   = var.tag_program
    Contact     = var.tag_contact
  }
}

// TODO: Set to fixed ip of API gateway, or use authentication on load balancer
resource "aws_security_group_rule" "lb_egress_rule" {
  count = length(var.ecs_sg_ports)

  description              = "Docs Load Balancer To Task on port ${element(var.ecs_sg_ports, count.index)}"
  type                     = "egress"
  from_port                = element(split("-", element(var.ecs_sg_ports, count.index)), 0)
  to_port                  = element(split("-", element(var.ecs_sg_ports, count.index)), 1)
  protocol                 = "tcp"
  source_security_group_id = var.ecs_sg_id
  security_group_id        = aws_security_group.docs-lb.id
}

resource "aws_security_group_rule" "task_ingress_rule" {
  count = length(var.ecs_sg_ports)

  description              = "Docs Load Balancer To Task on port ${element(var.ecs_sg_ports, count.index)}"
  type                     = "ingress"
  from_port                = element(split("-", element(var.ecs_sg_ports, count.index)), 0)
  to_port                  = element(split("-", element(var.ecs_sg_ports, count.index)), 1)
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.docs-lb.id
  security_group_id        = var.ecs_sg_id
}

