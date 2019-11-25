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

variable "authorization" {
}

variable "api_key_required" {
}

resource "aws_api_gateway_resource" "feeds_root" {
  rest_api_id = var.rest_api_id
  parent_id   = var.parent_id
  path_part   = "feeds"
}
