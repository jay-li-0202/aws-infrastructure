resource "aws_security_group" "basisregisters-db" {
  name        = "basisregisters-db-sg"
  description = "Security group for Basisregisters RDS"
  vpc_id      = "${var.vpc_id}"

  tags {
    Name = "SQL Server RDS // ${var.environment_label} ${var.environment_name}"
    Environment = "${var.tag_environment}"
    Productcode = "${var.tag_product}"
    Programma   = "${var.tag_program}"
    Contact     = "${var.tag_contact}"
  }
}
