module "cors-crabsubadressen1" {
  source          = "../cors"
  api_id          = var.rest_api_id
  api_resource_id = aws_api_gateway_resource.crabsubadressen_root1.id
}

resource "aws_api_gateway_method" "get-crabsubadressen1" {
  rest_api_id          = var.rest_api_id
  resource_id          = aws_api_gateway_resource.crabsubadressen_root1.id
  http_method          = "GET"
  authorization        = "CUSTOM"
  request_validator_id = var.request_validator_id
  api_key_required     = true
  authorizer_id        = var.authorizer_id

  request_parameters = {
    "method.request.header.Accept" = false
    "method.request.header.Cookie" = false
    "method.request.header.Host"   = true
  }
}

module "cors-crabsubadressen2" {
  source          = "../cors"
  api_id          = var.rest_api_id
  api_resource_id = aws_api_gateway_resource.crabsubadressen_root2.id
}

resource "aws_api_gateway_method" "get-crabsubadressen2" {
  rest_api_id          = var.rest_api_id
  resource_id          = aws_api_gateway_resource.crabsubadressen_root2.id
  http_method          = "GET"
  authorization        = "CUSTOM"
  request_validator_id = var.request_validator_id
  api_key_required     = true
  authorizer_id        = var.authorizer_id

  request_parameters = {
    "method.request.header.Accept" = false
    "method.request.header.Cookie" = false
    "method.request.header.Host"   = true
  }
}

module "cors-crabsubadressen3" {
  source          = "../cors"
  api_id          = var.rest_api_id
  api_resource_id = aws_api_gateway_resource.crabsubadressen_root3.id
}

resource "aws_api_gateway_method" "get-crabsubadressen3" {
  rest_api_id          = var.rest_api_id
  resource_id          = aws_api_gateway_resource.crabsubadressen_root3.id
  http_method          = "GET"
  authorization        = "CUSTOM"
  request_validator_id = var.request_validator_id
  api_key_required     = true
  authorizer_id        = var.authorizer_id

  request_parameters = {
    "method.request.header.Accept" = false
    "method.request.header.Cookie" = false
    "method.request.header.Host"   = true
  }
}

resource "aws_api_gateway_integration" "get-crabsubadressen-integration1" {
  rest_api_id = var.rest_api_id
  resource_id = aws_api_gateway_resource.crabsubadressen_root1.id
  http_method = aws_api_gateway_method.get-crabsubadressen1.http_method

  type                    = "HTTP_PROXY"
  integration_http_method = "GET"
  passthrough_behavior    = "WHEN_NO_MATCH"
  connection_type         = "VPC_LINK"
  connection_id           = var.vpc_link_id

  uri = "http://$${stageVariables.baseHost}/v1/crabsubadressen/"

  request_parameters = {
    "integration.request.header.Accept"          = "method.request.header.Accept"
    "integration.request.header.Cookie"          = "method.request.header.Cookie"
    "integration.request.header.Host"            = "stageVariables.baseHost"
    "integration.request.header.Accept-Encoding" = "'identity'"
  }
}

resource "aws_api_gateway_integration" "get-crabsubadressen-integration2" {
  rest_api_id = var.rest_api_id
  resource_id = aws_api_gateway_resource.crabsubadressen_root2.id
  http_method = aws_api_gateway_method.get-crabsubadressen2.http_method

  type                    = "HTTP_PROXY"
  integration_http_method = "GET"
  passthrough_behavior    = "WHEN_NO_MATCH"
  connection_type         = "VPC_LINK"
  connection_id           = var.vpc_link_id

  uri = "http://$${stageVariables.baseHost}/v1/crabsubadressen.json"

  request_parameters = {
    "integration.request.header.Accept"          = "method.request.header.Accept"
    "integration.request.header.Cookie"          = "method.request.header.Cookie"
    "integration.request.header.Host"            = "stageVariables.baseHost"
    "integration.request.header.Accept-Encoding" = "'identity'"
  }
}

resource "aws_api_gateway_integration" "get-crabsubadressen-integration3" {
  rest_api_id = var.rest_api_id
  resource_id = aws_api_gateway_resource.crabsubadressen_root3.id
  http_method = aws_api_gateway_method.get-crabsubadressen3.http_method

  type                    = "HTTP_PROXY"
  integration_http_method = "GET"
  passthrough_behavior    = "WHEN_NO_MATCH"
  connection_type         = "VPC_LINK"
  connection_id           = var.vpc_link_id

  uri = "http://$${stageVariables.baseHost}/v1/crabsubadressen.xml"

  request_parameters = {
    "integration.request.header.Accept"          = "method.request.header.Accept"
    "integration.request.header.Cookie"          = "method.request.header.Cookie"
    "integration.request.header.Host"            = "stageVariables.baseHost"
    "integration.request.header.Accept-Encoding" = "'identity'"
  }
}
