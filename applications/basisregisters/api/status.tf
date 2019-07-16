resource "aws_api_gateway_resource" "status" {
  rest_api_id = "${aws_api_gateway_rest_api.gw.id}"
  parent_id   = "${aws_api_gateway_rest_api.gw.root_resource_id}"
  path_part   = "status"
}

resource "aws_api_gateway_method" "get-status" {
  rest_api_id          = "${aws_api_gateway_rest_api.gw.id}"
  resource_id          = "${aws_api_gateway_resource.status.id}"
  http_method          = "GET"
  authorization        = "CUSTOM"
  request_validator_id = "${aws_api_gateway_request_validator.gw.id}"
  api_key_required     = true
  authorizer_id        = "${aws_api_gateway_authorizer.gw.id}"

  request_parameters = {
    "method.request.header.Accept" = false
    "method.request.header.Cookie" = false
    "method.request.header.Host"   = true
  }
}

resource "aws_api_gateway_integration" "get-status-integration" {
  rest_api_id = "${aws_api_gateway_rest_api.gw.id}"
  resource_id = "${aws_api_gateway_resource.status.id}"
  http_method = "${aws_api_gateway_method.get-status.http_method}"

  type                    = "HTTP_PROXY"
  integration_http_method = "GET"
  passthrough_behavior    = "WHEN_NO_MATCH"

  uri = "https://$${stageVariables.baseHost}/v1/status/"

  request_parameters = {
    "integration.request.header.Accept"          = "method.request.header.Accept"
    "integration.request.header.Cookie"          = "method.request.header.Cookie"
    "integration.request.header.Host"            = "stageVariables.baseHost"
    "integration.request.header.Accept-Encoding" = "'identity'"
  }
}
