module "cors-adresvoorstellingen1" {
  source          = "../../cors"
  api_id          = var.rest_api_id
  api_resource_id = aws_api_gateway_resource.adresvoorstellingen_root1.id
}

resource "aws_api_gateway_method" "get-adresvoorstellingen1" {
  rest_api_id          = var.rest_api_id
  resource_id          = aws_api_gateway_resource.adresvoorstellingen_root1.id
  http_method          = "POST"
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

module "cors-adresvoorstellingen2" {
  source          = "../../cors"
  api_id          = var.rest_api_id
  api_resource_id = aws_api_gateway_resource.adresvoorstellingen_root2.id
}

resource "aws_api_gateway_method" "get-adresvoorstellingen2" {
  rest_api_id          = var.rest_api_id
  resource_id          = aws_api_gateway_resource.adresvoorstellingen_root2.id
  http_method          = "POST"
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

module "cors-adresvoorstellingen3" {
  source          = "../../cors"
  api_id          = var.rest_api_id
  api_resource_id = aws_api_gateway_resource.adresvoorstellingen_root3.id
}

resource "aws_api_gateway_method" "get-adresvoorstellingen3" {
  rest_api_id          = var.rest_api_id
  resource_id          = aws_api_gateway_resource.adresvoorstellingen_root3.id
  http_method          = "POST"
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

resource "aws_api_gateway_integration" "get-adresvoorstellingen-integration1" {
  rest_api_id = var.rest_api_id
  resource_id = aws_api_gateway_resource.adresvoorstellingen_root1.id
  http_method = aws_api_gateway_method.get-adresvoorstellingen1.http_method

  type                    = "HTTP_PROXY"
  integration_http_method = "POST"
  passthrough_behavior    = "WHEN_NO_MATCH"
  connection_type         = "VPC_LINK"
  connection_id           = var.vpc_link_id

  uri = "http://$${stageVariables.baseHost}/v1/bosa/adresvoorstellingen/"

  request_parameters = {
    "integration.request.header.Accept"          = "method.request.header.Accept"
    "integration.request.header.Cookie"          = "method.request.header.Cookie"
    "integration.request.header.Host"            = "stageVariables.baseHost"
    "integration.request.header.Accept-Encoding" = "'identity'"
  }
}

resource "aws_api_gateway_integration" "get-adresvoorstellingen-integration2" {
  rest_api_id = var.rest_api_id
  resource_id = aws_api_gateway_resource.adresvoorstellingen_root2.id
  http_method = aws_api_gateway_method.get-adresvoorstellingen2.http_method

  type                    = "HTTP_PROXY"
  integration_http_method = "POST"
  passthrough_behavior    = "WHEN_NO_MATCH"
  connection_type         = "VPC_LINK"
  connection_id           = var.vpc_link_id

  uri = "http://$${stageVariables.baseHost}/v1/bosa/adresvoorstellingen.json"

  request_parameters = {
    "integration.request.header.Accept"          = "method.request.header.Accept"
    "integration.request.header.Cookie"          = "method.request.header.Cookie"
    "integration.request.header.Host"            = "stageVariables.baseHost"
    "integration.request.header.Accept-Encoding" = "'identity'"
  }
}

resource "aws_api_gateway_integration" "get-adresvoorstellingen-integration3" {
  rest_api_id = var.rest_api_id
  resource_id = aws_api_gateway_resource.adresvoorstellingen_root3.id
  http_method = aws_api_gateway_method.get-adresvoorstellingen3.http_method

  type                    = "HTTP_PROXY"
  integration_http_method = "POST"
  passthrough_behavior    = "WHEN_NO_MATCH"
  connection_type         = "VPC_LINK"
  connection_id           = var.vpc_link_id

  uri = "http://$${stageVariables.baseHost}/v1/bosa/adresvoorstellingen.xml"

  request_parameters = {
    "integration.request.header.Accept"          = "method.request.header.Accept"
    "integration.request.header.Cookie"          = "method.request.header.Cookie"
    "integration.request.header.Host"            = "stageVariables.baseHost"
    "integration.request.header.Accept-Encoding" = "'identity'"
  }
}
