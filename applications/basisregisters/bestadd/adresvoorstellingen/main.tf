variable "rest_api_id" {}
variable "parent_id" {}
variable "request_validator_id" {}
variable "authorizer_id" {}

resource "aws_api_gateway_resource" "adresvoorstellingen_root1" {
  rest_api_id = "${var.rest_api_id}"
  parent_id   = "${var.parent_id}"
  path_part   = "adresvoorstellingen"
}

resource "aws_api_gateway_resource" "adresvoorstellingen_root2" {
  rest_api_id = "${var.rest_api_id}"
  parent_id   = "${var.parent_id}"
  path_part   = "adresvoorstellingen.json"
}

resource "aws_api_gateway_resource" "adresvoorstellingen_root3" {
  rest_api_id = "${var.rest_api_id}"
  parent_id   = "${var.parent_id}"
  path_part   = "adresvoorstellingen.xml"
}
