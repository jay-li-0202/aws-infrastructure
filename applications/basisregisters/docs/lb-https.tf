resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.docs.id
  port              = var.lb_https_port
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"
  certificate_arn   = aws_acm_certificate.docs.arn

  default_action {
    target_group_arn = aws_lb_target_group.docs.id
    type             = "forward"
  }
}

resource "aws_lb_listener_rule" "redirect_docs1" {
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

resource "aws_lb_listener_rule" "redirect_docs2" {
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
    values = ["/v1*"]
  }
}

# Incoming HTTPS
resource "aws_security_group_rule" "ingress_https" {
  type = "ingress"

  from_port   = var.lb_https_port
  to_port     = var.lb_https_port
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  description = "Docs Load Balancer (HTTPS)"

  security_group_id = aws_security_group.docs-lb.id
}
