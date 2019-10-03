resource "aws_lb_target_group" "projections" {
  name                 = "organisation-projections"
  port                 = var.port_range + 6
  protocol             = "HTTP"
  vpc_id               = var.vpc_id
  target_type          = "ip"
  deregistration_delay = var.deregistration_delay

  health_check {
    interval = 300
    timeout  = 60
    path     = "/health"
  }

  tags = {
    Name        = "Organisation Projections // ${var.environment_label} ${var.environment_name}"
    Environment = var.tag_environment
    Productcode = var.tag_product
    Programma   = var.tag_program
    Contact     = var.tag_contact
  }
}

resource "aws_lb_listener_rule" "projections" {
  listener_arn = var.ops_lb_listener_arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.projections.id
  }

  condition {
    field  = "host-header"
    values = ["organisation-projections.*"]
  }
}
