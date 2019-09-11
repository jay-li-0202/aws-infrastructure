resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.main.id
  port              = var.lb_https_port
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"
  certificate_arn   = aws_acm_certificate.main.arn

  default_action {
    target_group_arn = aws_lb_target_group.main.id
    type             = "forward"
  }
}

resource "aws_lb_listener_rule" "redirect_alternate_host_headers" {
  listener_arn = aws_lb_listener.https.arn

  action {
    type = "redirect"

    redirect {
      host        = "ops-api.${replace(var.public_zone_name, "/[.]$/", "")}"
      status_code = "HTTP_301"
    }
  }

  condition {
    field  = "host-header"
    values = ["dev-api.*"]
  }
}
