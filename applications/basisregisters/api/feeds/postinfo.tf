resource "aws_api_gateway_resource" "postinfo_detail1" {
  rest_api_id = var.rest_api_id
  parent_id   = aws_api_gateway_resource.feeds_root.id
  path_part   = "postinfo"
}

resource "aws_api_gateway_resource" "postinfo_detail2" {
  rest_api_id = var.rest_api_id
  parent_id   = aws_api_gateway_resource.feeds_root.id
  path_part   = "postinfo.xml"
}

resource "aws_api_gateway_resource" "postinfo_detail3" {
  rest_api_id = var.rest_api_id
  parent_id   = aws_api_gateway_resource.feeds_root.id
  path_part   = "postinfo.atom"
}

module "cors-postinfo1" {
  source          = "../../cors"
  api_id          = var.rest_api_id
  api_resource_id = aws_api_gateway_resource.postinfo_detail1.id
}

resource "aws_api_gateway_method" "get-postinfo1" {
  rest_api_id          = var.rest_api_id
  resource_id          = aws_api_gateway_resource.postinfo_detail1.id
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

module "cors-postinfo2" {
  source          = "../../cors"
  api_id          = var.rest_api_id
  api_resource_id = aws_api_gateway_resource.postinfo_detail2.id
}

resource "aws_api_gateway_method" "get-postinfo2" {
  rest_api_id          = var.rest_api_id
  resource_id          = aws_api_gateway_resource.postinfo_detail2.id
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

module "cors-postinfo3" {
  source          = "../../cors"
  api_id          = var.rest_api_id
  api_resource_id = aws_api_gateway_resource.postinfo_detail3.id
}

resource "aws_api_gateway_method" "get-postinfo3" {
  rest_api_id          = var.rest_api_id
  resource_id          = aws_api_gateway_resource.postinfo_detail3.id
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

resource "aws_api_gateway_integration" "get-postinfo-integration1" {
  rest_api_id = var.rest_api_id
  resource_id = aws_api_gateway_resource.postinfo_detail1.id
  http_method = aws_api_gateway_method.get-postinfo1.http_method

  type                    = "HTTP_PROXY"
  integration_http_method = "GET"
  passthrough_behavior    = "WHEN_NO_MATCH"
  connection_type         = "VPC_LINK"
  connection_id           = var.vpc_link_id

  uri = "http://$${stageVariables.baseHost}/v1/feeds/postinfo"

  request_parameters = {
    "integration.request.header.Accept"          = "method.request.header.Accept"
    "integration.request.header.Cookie"          = "method.request.header.Cookie"
    "integration.request.header.Host"            = "stageVariables.baseHost"
    "integration.request.header.Accept-Encoding" = "'identity'"
  }
}

resource "aws_api_gateway_integration" "get-postinfo-integration2" {
  rest_api_id = var.rest_api_id
  resource_id = aws_api_gateway_resource.postinfo_detail2.id
  http_method = aws_api_gateway_method.get-postinfo2.http_method

  type                    = "HTTP_PROXY"
  integration_http_method = "GET"
  passthrough_behavior    = "WHEN_NO_MATCH"
  connection_type         = "VPC_LINK"
  connection_id           = var.vpc_link_id

  uri = "http://$${stageVariables.baseHost}/v1/feeds/postinfo.xml"

  request_parameters = {
    "integration.request.header.Cookie"          = "method.request.header.Cookie"
    "integration.request.header.Host"            = "stageVariables.baseHost"
    "integration.request.header.Accept-Encoding" = "'identity'"
  }
}

resource "aws_api_gateway_integration" "get-postinfo-integration3" {
  rest_api_id = var.rest_api_id
  resource_id = aws_api_gateway_resource.postinfo_detail3.id
  http_method = aws_api_gateway_method.get-postinfo3.http_method

  type                    = "HTTP_PROXY"
  integration_http_method = "GET"
  passthrough_behavior    = "WHEN_NO_MATCH"
  connection_type         = "VPC_LINK"
  connection_id           = var.vpc_link_id

  uri = "http://$${stageVariables.baseHost}/v1/feeds/postinfo.atom"

  request_parameters = {
    "integration.request.header.Cookie"          = "method.request.header.Cookie"
    "integration.request.header.Host"            = "stageVariables.baseHost"
    "integration.request.header.Accept-Encoding" = "'identity'"
  }
}
