resource "aws_lb" "api" {
  name               = "${var.app}-public-api"
  internal           = true
  load_balancer_type = "network"
  subnets            = var.private_subnets

  enable_cross_zone_load_balancing = true

  tags = {
    Name        = "Public Api Load Balancer // ${var.environment_label} ${var.environment_name}"
    Environment = var.tag_environment
    Productcode = var.tag_product
    Programma   = var.tag_program
    Contact     = var.tag_contact
  }
}

resource "aws_api_gateway_vpc_link" "api" {
  name        = "${var.app}-api"
  target_arns = ["${aws_lb.api.arn}"]
}
