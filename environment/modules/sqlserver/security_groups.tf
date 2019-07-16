resource "aws_security_group" "basisregisters-db" {
  name        = "basisregisters-db-sg"
  description = "Security group for Basisregisters RDS"
  vpc_id      = var.vpc_id

  tags = {
    Name        = "SQL Server RDS // ${var.environment_label} ${var.environment_name}"
    Environment = var.tag_environment
    Productcode = var.tag_product
    Programma   = var.tag_program
    Contact     = var.tag_contact
  }
}

# Incoming SQL
resource "aws_security_group_rule" "ingress_bastion" {
  description              = "Bastion To SQL Server"
  type                     = "ingress"
  from_port                = "1433"
  to_port                  = "1433"
  protocol                 = "tcp"
  source_security_group_id = var.bastion_sg_id
  security_group_id        = aws_security_group.basisregisters-db.id
}

resource "aws_security_group_rule" "ingress_ecs" {
  description              = "ECS To SQL Server"
  type                     = "ingress"
  from_port                = "1433"
  to_port                  = "1433"
  protocol                 = "tcp"
  source_security_group_id = var.ecs_sg_id
  security_group_id        = aws_security_group.basisregisters-db.id
}

