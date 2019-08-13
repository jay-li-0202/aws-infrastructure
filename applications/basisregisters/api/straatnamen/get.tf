resource "aws_api_gateway_resource" "straatnaam_detail1" {
  rest_api_id = var.rest_api_id
  parent_id   = aws_api_gateway_resource.straatnamen_root1.id
  path_part   = "{straatnaamId}"
}

resource "aws_api_gateway_method" "get-straatnaam1" {
  rest_api_id          = var.rest_api_id
  resource_id          = aws_api_gateway_resource.straatnaam_detail1.id
  http_method          = "GET"
  authorization        = "CUSTOM"
  request_validator_id = var.request_validator_id
  api_key_required     = true
  authorizer_id        = var.authorizer_id

  request_parameters = {
    "method.request.path.straatnaamId"        = true
    "method.request.header.Accept"            = false
    "method.request.header.Cookie"            = false
    "method.request.header.Host"              = true
    "method.request.header.If-Modified-Since" = false
    "method.request.header.If-None-Match"     = false
  }
}

resource "aws_api_gateway_integration" "get-straatnaam-integration1" {
  rest_api_id = var.rest_api_id
  resource_id = aws_api_gateway_resource.straatnaam_detail1.id
  http_method = aws_api_gateway_method.get-straatnaam1.http_method

  type                    = "HTTP_PROXY"
  integration_http_method = "GET"
  passthrough_behavior    = "WHEN_NO_MATCH"
  connection_type         = "VPC_LINK"
  connection_id           = var.vpc_link_id

  uri = "https://$${stageVariables.baseHost}/v1/straatnamen/{straatnaamId}"

  request_parameters = {
    "integration.request.path.straatnaamId"        = "method.request.path.straatnaamId"
    "integration.request.header.Accept"            = "method.request.header.Accept"
    "integration.request.header.Cookie"            = "method.request.header.Cookie"
    "integration.request.header.If-Modified-Since" = "method.request.header.If-Modified-Since"
    "integration.request.header.If-None-Match"     = "method.request.header.If-None-Match"
    "integration.request.header.Host"              = "stageVariables.baseHost"
    "integration.request.header.Accept-Encoding"   = "'identity'"
  }
}

