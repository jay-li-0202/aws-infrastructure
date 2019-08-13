resource "aws_ecr_repository" "repo" {
  count = length(var.repository_names)

  name = element(var.repository_names, count.index)

  tags = {
    Name        = "Docker Repository // ${var.environment_label} ${var.environment_name}"
    Environment = var.tag_environment
    Productcode = var.tag_product
    Programma   = var.tag_program
    Contact     = var.tag_contact
  }
}
