resource "aws_route" "nat_routes" {
  count                  = length(var.private_subnets)
  destination_cidr_block = "0.0.0.0/0"

  route_table_id = element(aws_route_table.private.*.id, count.index)
  nat_gateway_id = element(aws_nat_gateway.private.*.id, count.index)
}

resource "aws_eip" "nat_eip" {
  count = length(var.private_subnets)
  vpc   = true

  tags = {
    Name        = "NAT ${count.index + 1} // ${var.environment_label} ${var.environment_name}"
    Environment = var.tag_environment
    Productcode = var.tag_product
    Programma   = var.tag_program
    Contact     = var.tag_contact
  }
}

resource "aws_nat_gateway" "private" {
  count = length(var.private_subnets)

  allocation_id = element(aws_eip.nat_eip.*.id, count.index)
  subnet_id     = element(aws_subnet.public.*.id, count.index)

  tags = {
    Name        = "NAT ${count.index + 1} // ${var.environment_label} ${var.environment_name}"
    Environment = var.tag_environment
    Productcode = var.tag_product
    Programma   = var.tag_program
    Contact     = var.tag_contact
  }
}

