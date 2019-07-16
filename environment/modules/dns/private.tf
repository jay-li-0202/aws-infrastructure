resource "aws_route53_zone" "private" {
  name          = "${var.private_zone_name}"
  comment       = "Private zone for ${var.environment_label} ${var.environment_name}."
  force_destroy = true

  tags = {
    Name        = "Private Zone // ${var.environment_label} ${var.environment_name}"
    Environment = "${var.tag_environment}"
    Productcode = "${var.tag_product}"
    Programma   = "${var.tag_program}"
    Contact     = "${var.tag_contact}"
  }

  vpc {
    vpc_id = "${var.vpc_id}"
  }
}

resource "aws_vpc_dhcp_options" "vpc" {
  domain_name         = "${var.private_zone_name}"
  domain_name_servers = ["AmazonProvidedDNS"]

  tags = {
    Name        = "DHCP Options // ${var.environment_label} ${var.environment_name}"
    Environment = "${var.tag_environment}"
    Productcode = "${var.tag_product}"
    Programma   = "${var.tag_program}"
    Contact     = "${var.tag_contact}"
  }
}

resource "aws_vpc_dhcp_options_association" "vpc" {
  vpc_id          = "${var.vpc_id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.vpc.id}"
}
