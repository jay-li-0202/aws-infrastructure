resource "aws_lb_target_group" "api" {
  name                 = "publicservice-api"
  port                 = var.port_range + 2
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
    Name        = "PublicService Api // ${var.environment_label} ${var.environment_name}"
    Environment = var.tag_environment
    Productcode = var.tag_product
    Programma   = var.tag_program
    Contact     = var.tag_contact
  }
}

resource "aws_lb_listener_rule" "api" {
  listener_arn = var.public_lb_listener_arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api.id
  }

  condition {
    field  = "host-header"
    values = ["dienstverlening-api.*"]
  }
}

resource "aws_lb_target_group" "ui" {
  name                 = "publicservice-ui"
  port                 = var.port_range + 7
  protocol             = "HTTP"
  vpc_id               = var.vpc_id
  target_type          = "ip"
  deregistration_delay = var.deregistration_delay

  health_check {
    interval = 300
    timeout  = 60
    path     = "/"
  }

  tags = {
    Name        = "PublicService UI // ${var.environment_label} ${var.environment_name}"
    Environment = var.tag_environment
    Productcode = var.tag_product
    Programma   = var.tag_program
    Contact     = var.tag_contact
  }
}

resource "aws_lb_listener_rule" "ui" {
  listener_arn = var.public_lb_listener_arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ui.id
  }

  condition {
    field  = "host-header"
    values = ["dienstverlening.*"]
  }
}
