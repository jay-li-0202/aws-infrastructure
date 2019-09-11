resource "aws_lb_target_group" "api" {
  name                 = "${var.app}-public-api"
  port                 = var.lb_port
  protocol             = var.lb_protocol
  vpc_id               = var.vpc_id
  target_type          = "ip"
  deregistration_delay = var.deregistration_delay

  health_check {
    protocol = "HTTP"
    port     = var.container_port
    path     = "/health"
  }

  stickiness {
    type    = "lb_cookie"
    enabled = false
  }

  tags = {
    Name        = "Public Api // ${var.environment_label} ${var.environment_name}"
    Environment = var.tag_environment
    Productcode = var.tag_product
    Programma   = var.tag_program
    Contact     = var.tag_contact
  }
}

resource "aws_lb_listener" "tcp" {
  load_balancer_arn = var.api_lb_arn
  port              = var.lb_port
  protocol          = var.lb_protocol

  default_action {
    target_group_arn = aws_lb_target_group.api.id
    type             = "forward"
  }
}
