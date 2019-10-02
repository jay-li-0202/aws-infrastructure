resource "aws_api_gateway_resource" "perceel_detail1" {
  rest_api_id = var.rest_api_id
  parent_id   = aws_api_gateway_resource.feeds_root.id
  path_part   = "percelen"
}

resource "aws_api_gateway_resource" "perceel_detail2" {
  rest_api_id = var.rest_api_id
  parent_id   = aws_api_gateway_resource.feeds_root.id
  path_part   = "percelen.xml"
}

resource "aws_api_gateway_resource" "perceel_detail3" {
  rest_api_id = var.rest_api_id
  parent_id   = aws_api_gateway_resource.feeds_root.id
  path_part   = "percelen.atom"
}

module "cors-percelen1" {
  source          = "../../cors"
  api_id          = var.rest_api_id
  api_resource_id = aws_api_gateway_resource.perceel_detail1.id
}

resource "aws_api_gateway_method" "get-percelen1" {
  rest_api_id          = var.rest_api_id
  resource_id          = aws_api_gateway_resource.perceel_detail1.id
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

module "cors-percelen2" {
  source          = "../../cors"
  api_id          = var.rest_api_id
  api_resource_id = aws_api_gateway_resource.perceel_detail2.id
}

resource "aws_api_gateway_method" "get-percelen2" {
  rest_api_id          = var.rest_api_id
  resource_id          = aws_api_gateway_resource.perceel_detail2.id
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

module "cors-percelen3" {
  source          = "../../cors"
  api_id          = var.rest_api_id
  api_resource_id = aws_api_gateway_resource.perceel_detail3.id
}

resource "aws_api_gateway_method" "get-percelen3" {
  rest_api_id          = var.rest_api_id
  resource_id          = aws_api_gateway_resource.perceel_detail3.id
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

resource "aws_api_gateway_integration" "get-percelen-integration1" {
  rest_api_id = var.rest_api_id
  resource_id = aws_api_gateway_resource.perceel_detail1.id
  http_method = aws_api_gateway_method.get-percelen1.http_method

  type                    = "HTTP_PROXY"
  integration_http_method = "GET"
  passthrough_behavior    = "WHEN_NO_MATCH"
  connection_type         = "VPC_LINK"
  connection_id           = var.vpc_link_id

  uri = "http://$${stageVariables.baseHost}/v1/feeds/percelen"

  request_parameters = {
    "integration.request.header.Accept"          = "method.request.header.Accept"
    "integration.request.header.Cookie"          = "method.request.header.Cookie"
    "integration.request.header.Host"            = "stageVariables.baseHost"
    "integration.request.header.Accept-Encoding" = "'identity'"
  }
}

resource "aws_api_gateway_integration" "get-percelen-integration2" {
  rest_api_id = var.rest_api_id
  resource_id = aws_api_gateway_resource.perceel_detail2.id
  http_method = aws_api_gateway_method.get-percelen2.http_method

  type                    = "HTTP_PROXY"
  integration_http_method = "GET"
  passthrough_behavior    = "WHEN_NO_MATCH"
  connection_type         = "VPC_LINK"
  connection_id           = var.vpc_link_id

  uri = "http://$${stageVariables.baseHost}/v1/feeds/percelen.xml"

  request_parameters = {
    "integration.request.header.Cookie"          = "method.request.header.Cookie"
    "integration.request.header.Host"            = "stageVariables.baseHost"
    "integration.request.header.Accept-Encoding" = "'identity'"
  }
}

resource "aws_api_gateway_integration" "get-percelen-integration3" {
  rest_api_id = var.rest_api_id
  resource_id = aws_api_gateway_resource.perceel_detail3.id
  http_method = aws_api_gateway_method.get-percelen3.http_method

  type                    = "HTTP_PROXY"
  integration_http_method = "GET"
  passthrough_behavior    = "WHEN_NO_MATCH"
  connection_type         = "VPC_LINK"
  connection_id           = var.vpc_link_id

  uri = "http://$${stageVariables.baseHost}/v1/feeds/percelen.atom"

  request_parameters = {
    "integration.request.header.Cookie"          = "method.request.header.Cookie"
    "integration.request.header.Host"            = "stageVariables.baseHost"
    "integration.request.header.Accept-Encoding" = "'identity'"
  }
}
