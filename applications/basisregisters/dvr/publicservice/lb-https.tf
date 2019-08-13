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

resource "aws_lb_listener_rule" "ui" {
  listener_arn = aws_lb_listener.https.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ui.id
  }

  condition {
    field  = "host-header"
    values = ["dienstverlening.*"]
  }
}

# Incoming HTTPS
resource "aws_security_group_rule" "ingress_https" {
  type = "ingress"

  from_port   = var.lb_https_port
  to_port     = var.lb_https_port
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  description = "PublicService Load Balancer (HTTPS)"

  security_group_id = aws_security_group.api-lb.id
}
