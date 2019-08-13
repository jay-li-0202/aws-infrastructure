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

resource "aws_api_gateway_resource" "crabhuisnummers_root1" {
  rest_api_id = var.rest_api_id
  parent_id   = var.parent_id
  path_part   = "crabhuisnummers"
}

resource "aws_api_gateway_resource" "crabhuisnummers_root2" {
  rest_api_id = var.rest_api_id
  parent_id   = var.parent_id
  path_part   = "crabhuisnummers.json"
}

resource "aws_api_gateway_resource" "crabhuisnummers_root3" {
  rest_api_id = var.rest_api_id
  parent_id   = var.parent_id
  path_part   = "crabhuisnummers.xml"
}
