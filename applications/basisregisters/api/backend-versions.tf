resource "aws_api_gateway_resource" "versions" {
  rest_api_id = aws_api_gateway_rest_api.gw.id
  parent_id   = aws_api_gateway_rest_api.gw.root_resource_id
  path_part   = "versions"
}

module "cors-versions" {
  source          = "../cors"
  api_id          = aws_api_gateway_rest_api.gw.id
  api_resource_id = aws_api_gateway_resource.versions.id
}

resource "aws_api_gateway_method" "get-versions" {
  rest_api_id          = aws_api_gateway_rest_api.gw.id
  resource_id          = aws_api_gateway_resource.versions.id
  http_method          = "GET"
  authorization        = var.authorization
  request_validator_id = aws_api_gateway_request_validator.gw.id
  api_key_required     = var.api_key_required
  //authorizer_id        = aws_api_gateway_authorizer.gw.id

  request_parameters = {
    "method.request.header.Accept" = false
    "method.request.header.Cookie" = false
    "method.request.header.Host"   = true
  }
}

resource "aws_api_gateway_integration" "get-versions-integration" {
  rest_api_id = aws_api_gateway_rest_api.gw.id
  resource_id = aws_api_gateway_resource.versions.id
  http_method = aws_api_gateway_method.get-versions.http_method

  type                    = "HTTP_PROXY"
  integration_http_method = "GET"
  passthrough_behavior    = "WHEN_NO_MATCH"
  connection_type         = "VPC_LINK"
  connection_id           = aws_api_gateway_vpc_link.api.id

  uri = "http://$${stageVariables.baseHost}/versions/"

  request_parameters = {
    "integration.request.header.Accept"          = "method.request.header.Accept"
    "integration.request.header.Cookie"          = "method.request.header.Cookie"
    "integration.request.header.Host"            = "stageVariables.baseHost"
    "integration.request.header.Accept-Encoding" = "'identity'"
  }
}
