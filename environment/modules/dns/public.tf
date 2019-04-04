resource "aws_route53_zone" "public" {
  name          = "${var.public_zone_name}"
  comment       = "Public zone for ${var.environment_label} ${var.environment_name}."
  force_destroy = true

  tags {
    Name        = "Public Zone // ${var.environment_label} ${var.environment_name}"
    Environment = "${var.tag_environment}"
    Productcode = "${var.tag_product}"
    Programma   = "${var.tag_program}"
    Contact     = "${var.tag_contact}"
  }
}
