variable "rest_api_id" {
}

variable "parent_id" {
}

variable "request_validator_id" {
}

variable "authorizer_id" {
}

resource "aws_api_gateway_resource" "gebouwen_root1" {
  rest_api_id = var.rest_api_id
  parent_id   = var.parent_id
  path_part   = "gebouwen"
}

resource "aws_api_gateway_resource" "gebouwen_root2" {
  rest_api_id = var.rest_api_id
  parent_id   = var.parent_id
  path_part   = "gebouwen.json"
}

resource "aws_api_gateway_resource" "gebouwen_root3" {
  rest_api_id = var.rest_api_id
  parent_id   = var.parent_id
  path_part   = "gebouwen.xml"
}

