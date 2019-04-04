resource "aws_ecs_cluster" "basisregisters" {
  name = "basisregisters-${lower(replace(var.environment_name, " ", "-"))}"

  tags {
    Name        = "ECS Cluster // ${var.environment_label} ${var.environment_name}"
    Environment = "${var.tag_environment}"
    Productcode = "${var.tag_product}"
    Programma   = "${var.tag_program}"
    Contact     = "${var.tag_contact}"
  }
}
