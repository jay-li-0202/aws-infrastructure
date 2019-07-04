resource "aws_api_gateway_method" "get-crabhuisnummers1" {
  rest_api_id          = "${var.rest_api_id}"
  resource_id          = "${aws_api_gateway_resource.crabhuisnummers_root1.id}"
  http_method          = "GET"
  authorization        = "CUSTOM"
  request_validator_id = "${var.request_validator_id}"
  api_key_required     = true
  authorizer_id        = "${var.authorizer_id}"

  request_parameters {
    "method.request.header.Accept" = false
    "method.request.header.Cookie" = false
    "method.request.header.Host"   = true
  }
}

resource "aws_api_gateway_method" "get-crabhuisnummers2" {
  rest_api_id          = "${var.rest_api_id}"
  resource_id          = "${aws_api_gateway_resource.crabhuisnummers_root2.id}"
  http_method          = "GET"
  authorization        = "CUSTOM"
  request_validator_id = "${var.request_validator_id}"
  api_key_required     = true
  authorizer_id        = "${var.authorizer_id}"

  request_parameters {
    "method.request.header.Accept" = false
    "method.request.header.Cookie" = false
    "method.request.header.Host"   = true
  }
}

resource "aws_api_gateway_method" "get-crabhuisnummers3" {
  rest_api_id          = "${var.rest_api_id}"
  resource_id          = "${aws_api_gateway_resource.crabhuisnummers_root3.id}"
  http_method          = "GET"
  authorization        = "CUSTOM"
  request_validator_id = "${var.request_validator_id}"
  api_key_required     = true
  authorizer_id        = "${var.authorizer_id}"

  request_parameters {
    "method.request.header.Accept" = false
    "method.request.header.Cookie" = false
    "method.request.header.Host"   = true
  }
}

resource "aws_api_gateway_integration" "get-crabhuisnummers-integration1" {
  rest_api_id = "${var.rest_api_id}"
  resource_id = "${aws_api_gateway_resource.crabhuisnummers_root1.id}"
  http_method = "${aws_api_gateway_method.get-crabhuisnummers1.http_method}"

  type                    = "HTTP_PROXY"
  integration_http_method = "GET"
  passthrough_behavior    = "WHEN_NO_MATCH"

  uri = "https://$${stageVariables.baseHost}/v1/crabhuisnummers/"

  request_parameters {
    "integration.request.header.Accept"          = "method.request.header.Accept"
    "integration.request.header.Cookie"          = "method.request.header.Cookie"
    "integration.request.header.Host"            = "stageVariables.baseHost"
    "integration.request.header.Accept-Encoding" = "'identity'"
  }
}

resource "aws_api_gateway_integration" "get-crabhuisnummers-integration2" {
  rest_api_id = "${var.rest_api_id}"
  resource_id = "${aws_api_gateway_resource.crabhuisnummers_root2.id}"
  http_method = "${aws_api_gateway_method.get-crabhuisnummers2.http_method}"

  type                    = "HTTP_PROXY"
  integration_http_method = "GET"
  passthrough_behavior    = "WHEN_NO_MATCH"

  uri = "https://$${stageVariables.baseHost}/v1/crabhuisnummers.json"

  request_parameters {
    "integration.request.header.Accept"          = "method.request.header.Accept"
    "integration.request.header.Cookie"          = "method.request.header.Cookie"
    "integration.request.header.Host"            = "stageVariables.baseHost"
    "integration.request.header.Accept-Encoding" = "'identity'"
  }
}

resource "aws_api_gateway_integration" "get-crabhuisnummers-integration3" {
  rest_api_id = "${var.rest_api_id}"
  resource_id = "${aws_api_gateway_resource.crabhuisnummers_root3.id}"
  http_method = "${aws_api_gateway_method.get-crabhuisnummers3.http_method}"

  type                    = "HTTP_PROXY"
  integration_http_method = "GET"
  passthrough_behavior    = "WHEN_NO_MATCH"

  uri = "https://$${stageVariables.baseHost}/v1/crabhuisnummers.xml"

  request_parameters {
    "integration.request.header.Accept"          = "method.request.header.Accept"
    "integration.request.header.Cookie"          = "method.request.header.Cookie"
    "integration.request.header.Host"            = "stageVariables.baseHost"
    "integration.request.header.Accept-Encoding" = "'identity'"
  }
}