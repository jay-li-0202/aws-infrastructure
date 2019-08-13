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

resource "aws_api_gateway_resource" "gemeenten_root1" {
  rest_api_id = var.rest_api_id
  parent_id   = var.parent_id
  path_part   = "gemeenten"
}

resource "aws_api_gateway_resource" "gemeenten_root2" {
  rest_api_id = var.rest_api_id
  parent_id   = var.parent_id
  path_part   = "gemeenten.json"
}

resource "aws_api_gateway_resource" "gemeenten_root3" {
  rest_api_id = var.rest_api_id
  parent_id   = var.parent_id
  path_part   = "gemeenten.xml"
}
