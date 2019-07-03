variable "rest_api_id" {}
variable "parent_id" {}
variable "request_validator_id" {}
variable "authorizer_id" {}

resource "aws_api_gateway_resource" "crabsubadressen_root1" {
  rest_api_id = "${var.rest_api_id}"
  parent_id   = "${var.parent_id}"
  path_part   = "crabsubadressen"
}

resource "aws_api_gateway_resource" "crabsubadressen_root2" {
  rest_api_id = "${var.rest_api_id}"
  parent_id   = "${var.parent_id}"
  path_part   = "crabsubadressen.json"
}

resource "aws_api_gateway_resource" "crabsubadressen_root3" {
  rest_api_id = "${var.rest_api_id}"
  parent_id   = "${var.parent_id}"
  path_part   = "crabsubadressen.xml"
}
