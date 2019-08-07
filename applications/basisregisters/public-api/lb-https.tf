resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.api.id
  port              = var.lb_https_port
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate.api.arn

  default_action {
    target_group_arn = aws_lb_target_group.api.id
    type             = "forward"
  }
}

resource "aws_lb_listener_rule" "redirect_docs" {
  listener_arn = aws_lb_listener.https.arn

  action {
    type = "redirect"

    redirect {
      host        = "#{host}"
      path        = "/docs/api-documentation.html"
      status_code = "HTTP_301"
    }
  }

  condition {
    field  = "host-header"
    values = ["docs.*"]
  }

  condition {
    field  = "path-pattern"
    values = ["/"]
  }
}

resource "aws_lb_listener_rule" "redirect_alternate_host_headers" {
  listener_arn = aws_lb_listener.https.arn

  action {
    type = "redirect"

    redirect {
      host        = "public-api.${replace(var.public_zone_name, "/[.]$/", "")}"
      status_code = "HTTP_301"
    }
  }

  condition {
    field  = "host-header"
    values = ["legacy-api.*"]
  }
}

# Incoming HTTPS
resource "aws_security_group_rule" "ingress_https" {
  type = "ingress"

  from_port   = var.lb_https_port
  to_port     = var.lb_https_port
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  description = "Public Api Load Balancer (HTTPS)"

  security_group_id = aws_security_group.api-lb.id
}

