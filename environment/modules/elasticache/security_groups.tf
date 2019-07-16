resource "aws_security_group" "elasticache" {
  name        = "elasticache-sg"
  description = "Security group for Elasticache Server Instances"
  vpc_id      = var.vpc_id

  tags = {
    Name        = "Elasticache Server // ${var.environment_label} ${var.environment_name}"
    Environment = var.tag_environment
    Productcode = var.tag_product
    Programma   = var.tag_program
    Contact     = var.tag_contact
  }
}

# Incoming SQL
resource "aws_security_group_rule" "ingress_bastion" {
  description              = "Bastion To Redis"
  type                     = "ingress"
  from_port                = "6379"
  to_port                  = "6379"
  protocol                 = "tcp"
  source_security_group_id = var.bastion_sg_id
  security_group_id        = aws_security_group.elasticache.id
}

resource "aws_security_group_rule" "ingress_ecs" {
  description              = "ECS To Redis"
  type                     = "ingress"
  from_port                = "6379"
  to_port                  = "6379"
  protocol                 = "tcp"
  source_security_group_id = var.ecs_sg_id
  security_group_id        = aws_security_group.elasticache.id
}

