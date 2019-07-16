resource "aws_security_group" "bastion" {
  name        = "${lower(replace(var.environment_label, " ", "-"))}-${lower(replace(var.environment_name, " ", "-"))}-bastion"
  description = "Security group for Bastion"
  vpc_id      = "${var.bastion_vpc}"

  tags = {
    Name        = "Bastion // ${var.environment_label} ${var.environment_name}"
    Environment = "${var.tag_environment}"
    Productcode = "${var.tag_product}"
    Programma   = "${var.tag_program}"
    Contact     = "${var.tag_contact}"
  }
}
