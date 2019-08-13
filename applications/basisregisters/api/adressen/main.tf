variable "rest_api_id" {
}

variable "parent_id" {
}

variable "request_validator_id" {
}

variable "authorizer_id" {
}

variable "vpc_link_id" {
}

resource "aws_api_gateway_resource" "adressen_root1" {
  rest_api_id = var.rest_api_id
  parent_id   = var.parent_id
  path_part   = "adressen"
}

resource "aws_api_gateway_resource" "adressen_root2" {
  rest_api_id = var.rest_api_id
  parent_id   = var.parent_id
  path_part   = "adressen.json"
}

resource "aws_api_gateway_resource" "adressen_root3" {
  rest_api_id = var.rest_api_id
  parent_id   = var.parent_id
  path_part   = "adressen.xml"
}

