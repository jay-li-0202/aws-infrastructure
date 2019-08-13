resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_block

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "VPC // ${var.environment_label} ${var.environment_name}"
    Environment = var.tag_environment
    Productcode = var.tag_product
    Programma   = var.tag_program
    Contact     = var.tag_contact
  }
}

resource "aws_subnet" "private" {
  count = length(var.private_subnets)

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = element(var.private_subnets, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = false

  tags = {
    Name        = "Private Subnet ${count.index + 1} // ${var.environment_label} ${var.environment_name}"
    Environment = var.tag_environment
    Productcode = var.tag_product
    Programma   = var.tag_program
    Contact     = var.tag_contact
  }
}

resource "aws_subnet" "public" {
  count = length(var.public_subnets)

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = element(var.public_subnets, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name        = "Public Subnet ${count.index + 1} // ${var.environment_label} ${var.environment_name}"
    Environment = var.tag_environment
    Productcode = var.tag_product
    Programma   = var.tag_program
    Contact     = var.tag_contact
  }
}
