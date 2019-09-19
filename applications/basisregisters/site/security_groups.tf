# Incoming HTTP
resource "aws_security_group_rule" "ingress_http" {
  count = length(var.admin_cidr_blocks)
  type  = "ingress"

  from_port   = "0"
  to_port     = "65535"
  protocol    = "tcp"
  cidr_blocks = [element(split("|", element(var.admin_cidr_blocks, count.index)), 0)]
  description = "Site Load Balancer (${element(split("|", element(var.admin_cidr_blocks, count.index)), 1)})"

  security_group_id = aws_security_group.main-lb.id
}

resource "aws_security_group" "main-lb" {
  name        = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-site-lb"
  description = "Security group for Site Balancer"
  vpc_id      = var.vpc_id

  tags = {
    Name        = "Site Load Balancer // ${var.environment_label} ${var.environment_name}"
    Environment = var.tag_environment
    Productcode = var.tag_product
    Programma   = var.tag_program
    Contact     = var.tag_contact
  }
}

resource "aws_security_group_rule" "lb_egress_rule" {
  description              = "Site Load Balancer To Task on port ${var.site_port}"
  type                     = "egress"
  from_port                = var.site_port
  to_port                  = var.site_port
  protocol                 = "tcp"
  source_security_group_id = var.ecs_sg_id
  security_group_id        = aws_security_group.main-lb.id
}

resource "aws_security_group_rule" "task_ingress_rule" {
  description              = "Site Load Balancer To Task on port ${var.site_port}"
  type                     = "ingress"
  from_port                = var.site_port
  to_port                  = var.site_port
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.main-lb.id
  security_group_id        = var.ecs_sg_id
}
