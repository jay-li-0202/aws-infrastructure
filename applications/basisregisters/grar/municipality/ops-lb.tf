resource "aws_lb_target_group" "legacy" {
  name                 = "municipality-legacy"
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
    Name        = "Municipality Legacy // ${var.environment_label} ${var.environment_name}"
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
    values = ["municipality-legacy.*"]
  }
}

resource "aws_lb_target_group" "import" {
  name                 = "municipality-import"
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
    Name        = "Municipality Import // ${var.environment_label} ${var.environment_name}"
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
    values = ["municipality-import.*"]
  }
}

resource "aws_lb_target_group" "extract" {
  name                 = "municipality-extract"
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
    Name        = "Municipality Extract // ${var.environment_label} ${var.environment_name}"
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
    values = ["municipality-extract.*"]
  }
}

resource "aws_lb_target_group" "projections" {
  name                 = "municipality-projections"
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
    Name        = "Municipality Projections // ${var.environment_label} ${var.environment_name}"
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
    values = ["municipality-projections.*"]
  }
}
