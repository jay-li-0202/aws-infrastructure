resource "aws_lb_target_group" "legacy" {
  name                 = "postal-legacy"
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
    Name        = "Postal Legacy // ${var.environment_label} ${var.environment_name}"
    Environment = var.tag_environment
    Productcode = var.tag_product
    Programma   = var.tag_program
    Contact     = var.tag_contact
  }
}

resource "aws_lb_listener_rule" "legacy" {
  listener_arn = var.ops_lb_listener_arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.legacy.id
  }

  condition {
    field  = "host-header"
    values = ["postal-legacy.*"]
  }
}

resource "aws_lb_target_group" "import" {
  name                 = "postal-import"
  port                 = var.port_range
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
    Name        = "Postal Import // ${var.environment_label} ${var.environment_name}"
    Environment = var.tag_environment
    Productcode = var.tag_product
    Programma   = var.tag_program
    Contact     = var.tag_contact
  }
}

resource "aws_lb_listener_rule" "import" {
  listener_arn = var.ops_lb_listener_arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.import.id
  }

  condition {
    field  = "host-header"
    values = ["postal-import.*"]
  }
}

resource "aws_lb_target_group" "extract" {
  name                 = "postal-extract"
  port                 = var.port_range + 4
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
    Name        = "Postal Extract // ${var.environment_label} ${var.environment_name}"
    Environment = var.tag_environment
    Productcode = var.tag_product
    Programma   = var.tag_program
    Contact     = var.tag_contact
  }
}

resource "aws_lb_listener_rule" "extract" {
  listener_arn = var.ops_lb_listener_arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.extract.id
  }

  condition {
    field  = "host-header"
    values = ["postal-extract.*"]
  }
}

resource "aws_lb_target_group" "projections" {
  name                 = "postal-projections"
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
    Name        = "Postal Projections // ${var.environment_label} ${var.environment_name}"
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
    values = ["postal-projections.*"]
  }
}
