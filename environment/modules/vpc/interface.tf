variable "environment_label" {
  type = "string"
}

variable "environment_name" {
  type = "string"
}

variable "tag_environment" {
  type = "string"
}

variable "tag_product" {
  type = "string"
}

variable "tag_program" {
  type = "string"
}

variable "tag_contact" {
  type = "string"
}

variable "availability_zones" {
  description = "List of availability zones across which to distribute subnets"
  type        = "list"
}

variable "cidr_block" {
  description = "The VPC address space in CIDR notation"
  type        = "string"
}

variable "private_subnets" {
  description = "List of private subnet address spaces in CIDR notation"
  type        = "list"
}

variable "public_subnets" {
  description = "List of public subnet address spaces in CIDR notation"
  type        = "list"
}

variable "region" {
  description = "Region into which the VPC is deployed"
  type        = "string"
}

variable "log_group_retention_in_days" {
  type = "string"
}

output "cidr_block" {
  value = "${aws_vpc.vpc.cidr_block}"
}

output "private_subnets" {
  value = ["${aws_subnet.private.*.id}"]
}

output "private_availability_zones" {
  value = ["${aws_subnet.private.*.availability_zone}"]
}

output "public_availability_zones" {
  value = ["${aws_subnet.public.*.availability_zone}"]
}

output "public_subnets" {
  value = ["${aws_subnet.public.*.id}"]
}

output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

output "s3_vpce_id" {
  value = "${aws_vpc_endpoint.s3.id}"
}

output "aws_default_security_group_id" {
  value = "${aws_default_security_group.default.id}"
}

output "aws_default_network_acl_id" {
  value = "${aws_default_network_acl.default.id}"
}
