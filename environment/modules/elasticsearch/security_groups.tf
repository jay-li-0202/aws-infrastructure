resource "aws_security_group" "elasticsearch" {
  name        = "elasticsearch-sg"
  description = "Security group for Elasticsearch Server Instances"
  vpc_id      = var.vpc_id

  tags = {
    Name        = "Elasticsearch Server // ${var.environment_label} ${var.environment_name}"
    Environment = var.tag_environment
    Productcode = var.tag_product
    Programma   = var.tag_program
    Contact     = var.tag_contact
  }
}

# Incoming Elasticsearch
resource "aws_security_group_rule" "ingress_bastion" {
  description              = "Bastion To Elasticsearch"
  type                     = "ingress"
  from_port                = "443"
  to_port                  = "443"
  protocol                 = "tcp"
  source_security_group_id = var.bastion_sg_id
  security_group_id        = aws_security_group.elasticsearch.id
}

resource "aws_security_group_rule" "ingress_ecs" {
  description              = "ECS To Elasticsearch"
  type                     = "ingress"
  from_port                = "443"
  to_port                  = "443"
  protocol                 = "tcp"
  source_security_group_id = var.ecs_sg_id
  security_group_id        = aws_security_group.elasticsearch.id
}
