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

