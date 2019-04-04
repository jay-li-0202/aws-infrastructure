resource "aws_internet_gateway" "vpc" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name        = "Gateway // ${var.environment_label} ${var.environment_name}"
    Environment = "${var.tag_environment}"
    Productcode = "${var.tag_product}"
    Programma   = "${var.tag_program}"
    Contact     = "${var.tag_contact}"
  }
}

resource "aws_route_table" "private" {
  count  = "${length(var.private_subnets)}"
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name        = "Gateway ${count.index + 1} // ${var.environment_label} ${var.environment_name}"
    Environment = "${var.tag_environment}"
    Productcode = "${var.tag_product}"
    Programma   = "${var.tag_program}"
    Contact     = "${var.tag_contact}"
  }
}

resource "aws_route_table_association" "private" {
  count = "${length(var.private_subnets)}"

  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.vpc.id}"
  }

  tags {
    Name        = "Public // ${var.environment_label} ${var.environment_name}"
    Environment = "${var.tag_environment}"
    Productcode = "${var.tag_product}"
    Programma   = "${var.tag_program}"
    Contact     = "${var.tag_contact}"
  }
}

resource "aws_route_table_association" "public" {
  count = "${length(var.public_subnets)}"

  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id       = "${aws_vpc.vpc.id}"
  service_name = "com.amazonaws.${var.region}.s3"

  route_table_ids = [
    "${aws_route_table.private.*.id}",
    "${aws_route_table.public.*.id}",
  ]
}
