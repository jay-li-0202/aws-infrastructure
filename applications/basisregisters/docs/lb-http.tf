resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.docs.id
  port              = var.lb_port
  protocol          = var.lb_protocol

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# Incoming HTTP
resource "aws_security_group_rule" "ingress_http" {
  type = "ingress"

  from_port   = var.lb_port
  to_port     = var.lb_port
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  description = "Docs Load Balancer (${var.lb_protocol})"

  security_group_id = aws_security_group.docs-lb.id
}

