resource "aws_api_gateway_resource" "straatnaam_detail1" {
  rest_api_id = "${var.rest_api_id}"
  parent_id   = "${aws_api_gateway_resource.feeds_root.id}"
  path_part   = "straatnamen"
}

resource "aws_api_gateway_resource" "straatnaam_detail2" {
  rest_api_id = "${var.rest_api_id}"
  parent_id   = "${aws_api_gateway_resource.feeds_root.id}"
  path_part   = "straatnamen.xml"
}

resource "aws_api_gateway_resource" "straatnaam_detail3" {
  rest_api_id = "${var.rest_api_id}"
  parent_id   = "${aws_api_gateway_resource.feeds_root.id}"
  path_part   = "straatnamen.atom"
}

resource "aws_api_gateway_method" "get-straatnamen1" {
  rest_api_id          = "${var.rest_api_id}"
  resource_id          = "${aws_api_gateway_resource.straatnaam_detail1.id}"
  http_method          = "GET"
  authorization        = "CUSTOM"
  request_validator_id = "${var.request_validator_id}"
  api_key_required     = true
  authorizer_id        = "${var.authorizer_id}"

  request_parameters = {
    "method.request.header.Accept" = false
    "method.request.header.Cookie" = false
    "method.request.header.Host"   = true
  }
}

resource "aws_api_gateway_method" "get-straatnamen2" {
  rest_api_id          = "${var.rest_api_id}"
  resource_id          = "${aws_api_gateway_resource.straatnaam_detail2.id}"
  http_method          = "GET"
  authorization        = "CUSTOM"
  request_validator_id = "${var.request_validator_id}"
  api_key_required     = true
  authorizer_id        = "${var.authorizer_id}"

  request_parameters = {
    "method.request.header.Accept" = false
    "method.request.header.Cookie" = false
    "method.request.header.Host"   = true
  }
}

resource "aws_api_gateway_method" "get-straatnamen3" {
  rest_api_id          = "${var.rest_api_id}"
  resource_id          = "${aws_api_gateway_resource.straatnaam_detail3.id}"
  http_method          = "GET"
  authorization        = "CUSTOM"
  request_validator_id = "${var.request_validator_id}"
  api_key_required     = true
  authorizer_id        = "${var.authorizer_id}"

  request_parameters = {
    "method.request.header.Accept" = false
    "method.request.header.Cookie" = false
    "method.request.header.Host"   = true
  }
}

resource "aws_api_gateway_integration" "get-straatnamen-integration1" {
  rest_api_id = "${var.rest_api_id}"
  resource_id = "${aws_api_gateway_resource.straatnaam_detail1.id}"
  http_method = "${aws_api_gateway_method.get-straatnamen1.http_method}"

  type                    = "HTTP_PROXY"
  integration_http_method = "GET"
  passthrough_behavior    = "WHEN_NO_MATCH"

  uri = "https://$${stageVariables.baseHost}/v1/feeds/straatnamen"

  request_parameters = {
    "integration.request.header.Accept"          = "method.request.header.Accept"
    "integration.request.header.Cookie"          = "method.request.header.Cookie"
    "integration.request.header.Host"            = "stageVariables.baseHost"
    "integration.request.header.Accept-Encoding" = "'identity'"
  }
}

resource "aws_api_gateway_integration" "get-straatnamen-integration2" {
  rest_api_id = "${var.rest_api_id}"
  resource_id = "${aws_api_gateway_resource.straatnaam_detail2.id}"
  http_method = "${aws_api_gateway_method.get-straatnamen2.http_method}"

  type                    = "HTTP_PROXY"
  integration_http_method = "GET"
  passthrough_behavior    = "WHEN_NO_MATCH"

  uri = "https://$${stageVariables.baseHost}/v1/feeds/straatnamen.xml"

  request_parameters = {
    "integration.request.header.Cookie"          = "method.request.header.Cookie"
    "integration.request.header.Host"            = "stageVariables.baseHost"
    "integration.request.header.Accept-Encoding" = "'identity'"
  }
}

resource "aws_api_gateway_integration" "get-straatnamen-integration3" {
  rest_api_id = "${var.rest_api_id}"
  resource_id = "${aws_api_gateway_resource.straatnaam_detail3.id}"
  http_method = "${aws_api_gateway_method.get-straatnamen3.http_method}"

  type                    = "HTTP_PROXY"
  integration_http_method = "GET"
  passthrough_behavior    = "WHEN_NO_MATCH"

  uri = "https://$${stageVariables.baseHost}/v1/feeds/straatnamen.atom"

  request_parameters = {
    "integration.request.header.Cookie"          = "method.request.header.Cookie"
    "integration.request.header.Host"            = "stageVariables.baseHost"
    "integration.request.header.Accept-Encoding" = "'identity'"
  }
}
