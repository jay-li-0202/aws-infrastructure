resource "aws_api_gateway_method" "get-dienstverleningen1" {
  rest_api_id          = var.rest_api_id
  resource_id          = aws_api_gateway_resource.dienstverleningen_root1.id
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

resource "aws_api_gateway_method" "get-dienstverleningen2" {
  rest_api_id          = var.rest_api_id
  resource_id          = aws_api_gateway_resource.dienstverleningen_root2.id
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

resource "aws_api_gateway_method" "get-dienstverleningen3" {
  rest_api_id          = var.rest_api_id
  resource_id          = aws_api_gateway_resource.dienstverleningen_root3.id
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

resource "aws_api_gateway_integration" "get-dienstverleningen-integration1" {
  rest_api_id = var.rest_api_id
  resource_id = aws_api_gateway_resource.dienstverleningen_root1.id
  http_method = aws_api_gateway_method.get-dienstverleningen1.http_method

  type                    = "HTTP_PROXY"
  integration_http_method = "GET"
  passthrough_behavior    = "WHEN_NO_MATCH"

  uri = "https://$${stageVariables.baseHost}/v1/dienstverleningen/"

  request_parameters = {
    "integration.request.header.Accept"          = "method.request.header.Accept"
    "integration.request.header.Cookie"          = "method.request.header.Cookie"
    "integration.request.header.Host"            = "stageVariables.baseHost"
    "integration.request.header.Accept-Encoding" = "'identity'"
  }
}

resource "aws_api_gateway_integration" "get-dienstverleningen-integration2" {
  rest_api_id = var.rest_api_id
  resource_id = aws_api_gateway_resource.dienstverleningen_root2.id
  http_method = aws_api_gateway_method.get-dienstverleningen2.http_method

  type                    = "HTTP_PROXY"
  integration_http_method = "GET"
  passthrough_behavior    = "WHEN_NO_MATCH"

  uri = "https://$${stageVariables.baseHost}/v1/dienstverleningen.json"

  request_parameters = {
    "integration.request.header.Accept"          = "method.request.header.Accept"
    "integration.request.header.Cookie"          = "method.request.header.Cookie"
    "integration.request.header.Host"            = "stageVariables.baseHost"
    "integration.request.header.Accept-Encoding" = "'identity'"
  }
}

resource "aws_api_gateway_integration" "get-dienstverleningen-integration3" {
  rest_api_id = var.rest_api_id
  resource_id = aws_api_gateway_resource.dienstverleningen_root3.id
  http_method = aws_api_gateway_method.get-dienstverleningen3.http_method

  type                    = "HTTP_PROXY"
  integration_http_method = "GET"
  passthrough_behavior    = "WHEN_NO_MATCH"

  uri = "https://$${stageVariables.baseHost}/v1/dienstverleningen.xml"

  request_parameters = {
    "integration.request.header.Accept"          = "method.request.header.Accept"
    "integration.request.header.Cookie"          = "method.request.header.Cookie"
    "integration.request.header.Host"            = "stageVariables.baseHost"
    "integration.request.header.Accept-Encoding" = "'identity'"
  }
}

