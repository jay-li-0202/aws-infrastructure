resource "aws_security_group_rule" "address" {
  description       = "Address Registry"
  type              = "ingress"
  from_port         = var.port_range
  to_port           = var.port_range + 6
  protocol          = "tcp"
  security_group_id = var.task_security_group_id
  self              = true
}
