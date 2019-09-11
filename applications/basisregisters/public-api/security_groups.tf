resource "aws_security_group_rule" "vpclink_ingress_rule" {
  description       = "VPC Link To Task on port ${var.container_port}"
  type              = "ingress"
  from_port         = var.container_port
  to_port           = var.container_port
  protocol          = "tcp"
  security_group_id = var.ecs_sg_id
  cidr_blocks       = [var.vpc_cidr_block]
}
