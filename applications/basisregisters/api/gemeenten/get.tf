resource "aws_api_gateway_resource" "gemeente_detail1" {
  rest_api_id = "${var.rest_api_id}"
  parent_id   = "${aws_api_gateway_resource.gemeenten_root1.id}"
  path_part   = "{gemeenteId}"
}

resource "aws_api_gateway_method" "get-gemeente1" {
  rest_api_id          = "${var.rest_api_id}"
  resource_id          = "${aws_api_gateway_resource.gemeente_detail1.id}"
  http_method          = "GET"
  authorization        = "CUSTOM"
  request_validator_id = "${var.request_validator_id}"
  api_key_required     = true
  authorizer_id        = "${var.authorizer_id}"

  request_parameters {
    "method.request.path.gemeenteId"          = true
    "method.request.header.Accept"            = false
    "method.request.header.Cookie"            = false
    "method.request.header.Host"              = true
    "method.request.header.If-Modified-Since" = false
    "method.request.header.If-None-Match"     = false
  }
}

resource "aws_api_gateway_integration" "get-gemeente-integration1" {
  rest_api_id = "${var.rest_api_id}"
  resource_id = "${aws_api_gateway_resource.gemeente_detail1.id}"
  http_method = "${aws_api_gateway_method.get-gemeente1.http_method}"

  type                    = "HTTP_PROXY"
  integration_http_method = "GET"
  passthrough_behavior    = "WHEN_NO_MATCH"

  uri = "https://$${stageVariables.baseHost}/v1/gemeenten/{gemeenteId}"

  request_parameters {
    "integration.request.path.gemeenteId"          = "method.request.path.gemeenteId"
    "integration.request.header.Accept"            = "method.request.header.Accept"
    "integration.request.header.Cookie"            = "method.request.header.Cookie"
    "integration.request.header.If-Modified-Since" = "method.request.header.If-Modified-Since"
    "integration.request.header.If-None-Match"     = "method.request.header.If-None-Match"
    "integration.request.header.Host"              = "stageVariables.baseHost"
    "integration.request.header.Accept-Encoding"   = "'identity'"
  }
}
