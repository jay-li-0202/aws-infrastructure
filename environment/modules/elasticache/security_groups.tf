resource "aws_security_group" "elasticache" {
  name        = "elasticache-sg"
  description = "Security group for Elasticache Server Instances"
  vpc_id      = "${var.vpc_id}"

  tags {
    Name        = "Elasticache Server // ${var.environment_label} ${var.environment_name}"
    Environment = "${var.tag_environment}"
    Productcode = "${var.tag_product}"
    Programma   = "${var.tag_program}"
    Contact     = "${var.tag_contact}"
  }
}
