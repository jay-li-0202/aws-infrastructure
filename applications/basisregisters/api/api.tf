resource "aws_api_gateway_deployment" "gw" {
  depends_on  = [aws_api_gateway_integration.get-versions-integration]
  rest_api_id = aws_api_gateway_rest_api.gw.id
  description = "Basisregisters Vlaanderen // ${var.environment_label} ${var.environment_name}"

  stage_name = ""

  stage_description = md5(
    "${file("${path.module}/api.tf")}\n${file("${path.module}/status.tf")}\n${file("${path.module}/feeds/main.tf")}\n${file("${path.module}/adresmatch/main.tf")}\n${file("${path.module}/adressen/main.tf")}\n${file("${path.module}/crabhuisnummers/main.tf")}\n${file("${path.module}/crabsubadressen/main.tf")}\n${file("${path.module}/dienstverleningen/main.tf")}\n${file("${path.module}/gebouwen/main.tf")}\n${file("${path.module}/gebouweenheden/main.tf")}\n${file("${path.module}/gemeenten/main.tf")}\n${file("${path.module}/percelen/main.tf")}\n${file("${path.module}/postinfo/main.tf")}\n${file("${path.module}/straatnamen/main.tf")}",
  )

  //   stage_description = <<EOF
  // ${md5("
  //   ${file("${path.module}/api.tf")}
  //   ${file("${path.module}/status.tf")}
  //   ${file("${path.module}/feeds/main.tf")}
  //   ${file("${path.module}/adresmatch/main.tf")}
  //   ${file("${path.module}/adressen/main.tf")}
  //   ${file("${path.module}/crabhuisnummers/main.tf")}
  //   ${file("${path.module}/crabsubadressen/main.tf")}
  //   ${file("${path.module}/dienstverleningen/main.tf")}
  //   ${file("${path.module}/gebouwen/main.tf")}
  //   ${file("${path.module}/gebouweenheden/main.tf")}
  //   ${file("${path.module}/gemeenten/main.tf")}
  //   ${file("${path.module}/percelen/main.tf")}
  //   ${file("${path.module}/postinfo/main.tf")}
  //   ${file("${path.module}/straatnamen/main.tf")}
  // ")}
  // EOF

  lifecycle {
    create_before_destroy = true
  }
}

variable "aws_api_gateway_method_settings_throttling_rate_limit" { default = 10000 }
variable "aws_api_gateway_method_settings_throttling_burst_limit" { default = 5000 }
resource "aws_api_gateway_method_settings" "gw" {
  rest_api_id = aws_api_gateway_rest_api.gw.id
  stage_name  = aws_api_gateway_stage.gw.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled    = true
    logging_level      = "INFO"
    data_trace_enabled = true

    // https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-request-throttling.html
    throttling_rate_limit  = var.aws_api_gateway_method_settings_throttling_rate_limit
    throttling_burst_limit = var.aws_api_gateway_method_settings_throttling_burst_limit
  }
}

resource "aws_api_gateway_base_path_mapping" "v1" {
  api_id      = aws_api_gateway_rest_api.gw.id
  stage_name  = aws_api_gateway_stage.gw.stage_name
  domain_name = aws_api_gateway_domain_name.gw.domain_name
  base_path   = "v1"
}

module "gemeenten" {
  source = "./gemeenten"

  rest_api_id          = aws_api_gateway_rest_api.gw.id
  parent_id            = aws_api_gateway_rest_api.gw.root_resource_id
  request_validator_id = aws_api_gateway_request_validator.gw.id
  authorizer_id        = aws_api_gateway_authorizer.gw.id
  vpc_link_id          = aws_api_gateway_vpc_link.api.id
}

module "postinfo" {
  source = "./postinfo"

  rest_api_id          = aws_api_gateway_rest_api.gw.id
  parent_id            = aws_api_gateway_rest_api.gw.root_resource_id
  request_validator_id = aws_api_gateway_request_validator.gw.id
  authorizer_id        = aws_api_gateway_authorizer.gw.id
  vpc_link_id          = aws_api_gateway_vpc_link.api.id
}

module "straatnamen" {
  source = "./straatnamen"

  rest_api_id          = aws_api_gateway_rest_api.gw.id
  parent_id            = aws_api_gateway_rest_api.gw.root_resource_id
  request_validator_id = aws_api_gateway_request_validator.gw.id
  authorizer_id        = aws_api_gateway_authorizer.gw.id
  vpc_link_id          = aws_api_gateway_vpc_link.api.id
}

module "adresmatch" {
  source = "./adresmatch"

  rest_api_id          = aws_api_gateway_rest_api.gw.id
  parent_id            = aws_api_gateway_rest_api.gw.root_resource_id
  request_validator_id = aws_api_gateway_request_validator.gw.id
  authorizer_id        = aws_api_gateway_authorizer.gw.id
  vpc_link_id          = aws_api_gateway_vpc_link.api.id
}

module "adressen" {
  source = "./adressen"

  rest_api_id          = aws_api_gateway_rest_api.gw.id
  parent_id            = aws_api_gateway_rest_api.gw.root_resource_id
  request_validator_id = aws_api_gateway_request_validator.gw.id
  authorizer_id        = aws_api_gateway_authorizer.gw.id
  vpc_link_id          = aws_api_gateway_vpc_link.api.id
}

module "crabhuisnummers" {
  source = "./crabhuisnummers"

  rest_api_id          = aws_api_gateway_rest_api.gw.id
  parent_id            = aws_api_gateway_rest_api.gw.root_resource_id
  request_validator_id = aws_api_gateway_request_validator.gw.id
  authorizer_id        = aws_api_gateway_authorizer.gw.id
  vpc_link_id          = aws_api_gateway_vpc_link.api.id
}

module "crabsubadressen" {
  source = "./crabsubadressen"

  rest_api_id          = aws_api_gateway_rest_api.gw.id
  parent_id            = aws_api_gateway_rest_api.gw.root_resource_id
  request_validator_id = aws_api_gateway_request_validator.gw.id
  authorizer_id        = aws_api_gateway_authorizer.gw.id
  vpc_link_id          = aws_api_gateway_vpc_link.api.id
}

module "gebouwen" {
  source = "./gebouwen"

  rest_api_id          = aws_api_gateway_rest_api.gw.id
  parent_id            = aws_api_gateway_rest_api.gw.root_resource_id
  request_validator_id = aws_api_gateway_request_validator.gw.id
  authorizer_id        = aws_api_gateway_authorizer.gw.id
  vpc_link_id          = aws_api_gateway_vpc_link.api.id
}

module "gebouweenheden" {
  source = "./gebouweenheden"

  rest_api_id          = aws_api_gateway_rest_api.gw.id
  parent_id            = aws_api_gateway_rest_api.gw.root_resource_id
  request_validator_id = aws_api_gateway_request_validator.gw.id
  authorizer_id        = aws_api_gateway_authorizer.gw.id
  vpc_link_id          = aws_api_gateway_vpc_link.api.id
}

module "percelen" {
  source = "./percelen"

  rest_api_id          = aws_api_gateway_rest_api.gw.id
  parent_id            = aws_api_gateway_rest_api.gw.root_resource_id
  request_validator_id = aws_api_gateway_request_validator.gw.id
  authorizer_id        = aws_api_gateway_authorizer.gw.id
  vpc_link_id          = aws_api_gateway_vpc_link.api.id
}

module "feeds" {
  source = "./feeds"

  rest_api_id          = aws_api_gateway_rest_api.gw.id
  parent_id            = aws_api_gateway_rest_api.gw.root_resource_id
  request_validator_id = aws_api_gateway_request_validator.gw.id
  authorizer_id        = aws_api_gateway_authorizer.gw.id
  vpc_link_id          = aws_api_gateway_vpc_link.api.id
}

module "dienstverleningen" {
  source = "./dienstverleningen"

  rest_api_id          = aws_api_gateway_rest_api.gw.id
  parent_id            = aws_api_gateway_rest_api.gw.root_resource_id
  request_validator_id = aws_api_gateway_request_validator.gw.id
  authorizer_id        = aws_api_gateway_authorizer.gw.id
  vpc_link_id          = aws_api_gateway_vpc_link.api.id
}

output "api_url" {
  value = aws_api_gateway_deployment.gw.invoke_url
}

resource "aws_api_gateway_stage" "gw" {
  stage_name    = var.api_stage_name
  rest_api_id   = aws_api_gateway_rest_api.gw.id
  deployment_id = aws_api_gateway_deployment.gw.id
  description   = "Basisregisters Vlaanderen // ${var.environment_label} ${var.environment_name}"

  variables = {
    baseHost = replace(var.base_host, "/[.]$/", "")
  }

  tags = {
    Name        = "Basisregisters Api Gateway Stage // ${var.environment_label} ${var.environment_name}"
    Environment = var.tag_environment
    Productcode = var.tag_product
    Programma   = var.tag_program
    Contact     = var.tag_contact
  }
}
