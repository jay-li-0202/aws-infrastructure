module "cors-gemeenten1" {
  source          = "../../cors"
  api_id          = var.rest_api_id
  api_resource_id = aws_api_gateway_resource.gemeenten_root1.id
}

resource "aws_api_gateway_method" "get-gemeenten1" {
  rest_api_id          = var.rest_api_id
  resource_id          = aws_api_gateway_resource.gemeenten_root1.id
  http_method          = "GET"
  authorization        = var.authorization
  request_validator_id = var.request_validator_id
  api_key_required     = var.api_key_required
  //authorizer_id        = var.authorizer_id

  request_parameters = {
    "method.request.header.Accept" = false
    "method.request.header.Cookie" = false
    "method.request.header.Host"   = true
  }
}

module "cors-gemeenten2" {
  source          = "../../cors"
  api_id          = var.rest_api_id
  api_resource_id = aws_api_gateway_resource.gemeenten_root2.id
}

resource "aws_api_gateway_method" "get-gemeenten2" {
  rest_api_id          = var.rest_api_id
  resource_id          = aws_api_gateway_resource.gemeenten_root2.id
  http_method          = "GET"
  authorization        = var.authorization
  request_validator_id = var.request_validator_id
  api_key_required     = var.api_key_required
  //authorizer_id        = var.authorizer_id

  request_parameters = {
    "method.request.header.Accept" = false
    "method.request.header.Cookie" = false
    "method.request.header.Host"   = true
  }
}

module "cors-gemeenten3" {
  source          = "../../cors"
  api_id          = var.rest_api_id
  api_resource_id = aws_api_gateway_resource.gemeenten_root3.id
}

resource "aws_api_gateway_method" "get-gemeenten3" {
  rest_api_id          = var.rest_api_id
  resource_id          = aws_api_gateway_resource.gemeenten_root3.id
  http_method          = "GET"
  authorization        = var.authorization
  request_validator_id = var.request_validator_id
  api_key_required     = var.api_key_required
  //authorizer_id        = var.authorizer_id

  request_parameters = {
    "method.request.header.Accept" = false
    "method.request.header.Cookie" = false
    "method.request.header.Host"   = true
  }
}

resource "aws_api_gateway_integration" "get-gemeenten-integration1" {
  rest_api_id = var.rest_api_id
  resource_id = aws_api_gateway_resource.gemeenten_root1.id
  http_method = aws_api_gateway_method.get-gemeenten1.http_method

  type                    = "HTTP_PROXY"
  integration_http_method = "GET"
  passthrough_behavior    = "WHEN_NO_MATCH"
  connection_type         = "VPC_LINK"
  connection_id           = var.vpc_link_id

  uri = "http://$${stageVariables.baseHost}/v1/gemeenten/"

  request_parameters = {
    "integration.request.header.Accept"          = "method.request.header.Accept"
    "integration.request.header.Cookie"          = "method.request.header.Cookie"
    "integration.request.header.Host"            = "stageVariables.baseHost"
    "integration.request.header.Accept-Encoding" = "'identity'"
  }
}

resource "aws_api_gateway_integration" "get-gemeenten-integration2" {
  rest_api_id = var.rest_api_id
  resource_id = aws_api_gateway_resource.gemeenten_root2.id
  http_method = aws_api_gateway_method.get-gemeenten2.http_method

  type                    = "HTTP_PROXY"
  integration_http_method = "GET"
  passthrough_behavior    = "WHEN_NO_MATCH"
  connection_type         = "VPC_LINK"
  connection_id           = var.vpc_link_id

  uri = "http://$${stageVariables.baseHost}/v1/gemeenten.json"

  request_parameters = {
    "integration.request.header.Accept"          = "method.request.header.Accept"
    "integration.request.header.Cookie"          = "method.request.header.Cookie"
    "integration.request.header.Host"            = "stageVariables.baseHost"
    "integration.request.header.Accept-Encoding" = "'identity'"
  }
}

resource "aws_api_gateway_integration" "get-gemeenten-integration3" {
  rest_api_id = var.rest_api_id
  resource_id = aws_api_gateway_resource.gemeenten_root3.id
  http_method = aws_api_gateway_method.get-gemeenten3.http_method

  type                    = "HTTP_PROXY"
  integration_http_method = "GET"
  passthrough_behavior    = "WHEN_NO_MATCH"
  connection_type         = "VPC_LINK"
  connection_id           = var.vpc_link_id

  uri = "http://$${stageVariables.baseHost}/v1/gemeenten.xml"

  request_parameters = {
    "integration.request.header.Accept"          = "method.request.header.Accept"
    "integration.request.header.Cookie"          = "method.request.header.Cookie"
    "integration.request.header.Host"            = "stageVariables.baseHost"
    "integration.request.header.Accept-Encoding" = "'identity'"
  }
}
