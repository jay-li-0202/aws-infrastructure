# Once in setup: https://www.terraform.io/docs/providers/aws/r/api_gateway_account.html
resource "aws_api_gateway_rest_api" "gw" {
  name        = "Basisregisters Vlaanderen"
  description = "Stelsel van Vlaamse Basisregisters."

  minimum_compression_size = 0
  api_key_source           = "AUTHORIZER"
  // binary_media_types = ["*/*"]
}

resource "aws_api_gateway_authorizer" "gw" {
  name                             = "gw"
  rest_api_id                      = aws_api_gateway_rest_api.gw.id
  authorizer_uri                   = aws_lambda_function.api-auth.invoke_arn
  authorizer_credentials           = aws_iam_role.invocation_role.arn
  type                             = "REQUEST"
  authorizer_result_ttl_in_seconds = 0
  identity_source                  = "context.requestId"
}

resource "aws_api_gateway_request_validator" "gw" {
  name                        = var.api_name
  rest_api_id                 = aws_api_gateway_rest_api.gw.id
  validate_request_body       = false
  validate_request_parameters = true
}

resource "aws_api_gateway_usage_plan" "gw-anonymous" {
  name        = "${var.api_name}-anonymous"
  description = "Basisregisters Vlaanderen Anoniem."

  api_stages {
    api_id = aws_api_gateway_rest_api.gw.id
    stage  = aws_api_gateway_stage.gw.stage_name
  }

  throttle_settings {
    burst_limit = var.aws_api_gateway_method_settings_throttling_burst_limit
    rate_limit  = var.aws_api_gateway_method_settings_throttling_rate_limit
  }
}

resource "aws_api_gateway_usage_plan" "gw-demo" {
  name        = "${var.api_name}-demo"
  description = "Basisregisters Vlaanderen Demo."

  api_stages {
    api_id = aws_api_gateway_rest_api.gw.id
    stage  = aws_api_gateway_stage.gw.stage_name
  }

  throttle_settings {
    burst_limit = 25
    rate_limit  = 50
  }
}

resource "aws_api_gateway_usage_plan" "gw-ui" {
  name        = "${var.api_name}-ui"
  description = "Basisregisters Vlaanderen UI."

  api_stages {
    api_id = aws_api_gateway_rest_api.gw.id
    stage  = aws_api_gateway_stage.gw.stage_name
  }

  throttle_settings {
    burst_limit = 25
    rate_limit  = 50
  }
}

resource "aws_api_gateway_usage_plan" "gw-portal" {
  name        = "${var.api_name}-portal"
  description = "Basisregisters Vlaanderen Portal."

  api_stages {
    api_id = aws_api_gateway_rest_api.gw.id
    stage  = aws_api_gateway_stage.gw.stage_name
  }

  throttle_settings {
    burst_limit = 5
    rate_limit  = 5
  }
}

resource "aws_api_gateway_usage_plan" "gw-test" {
  name        = "${var.api_name}-test"
  description = "Basisregisters Vlaanderen Test."

  api_stages {
    api_id = aws_api_gateway_rest_api.gw.id
    stage  = aws_api_gateway_stage.gw.stage_name
  }

  throttle_settings {
    burst_limit = 25
    rate_limit  = 50
  }
}

resource "aws_api_gateway_api_key" "gw-demo-key" {
  name        = "${var.api_name}-demo"
  description = "Basisregisters Vlaanderen Demo API Key."
  value       = var.demo_key
}

resource "aws_api_gateway_usage_plan_key" "gw-demo-key" {
  key_id        = aws_api_gateway_api_key.gw-demo-key.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.gw-demo.id
}

resource "aws_api_gateway_api_key" "gw-anonymous-key" {
  name        = "${var.api_name}-anonymous"
  description = "Basisregisters Vlaanderen Anoniem API Key."
  value       = var.anon_key
}

resource "aws_api_gateway_usage_plan_key" "gw-anonymous-key" {
  key_id        = aws_api_gateway_api_key.gw-anonymous-key.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.gw-anonymous.id
}

resource "aws_api_gateway_api_key" "gw-ui-key" {
  name        = "${var.api_name}-ui"
  description = "Basisregisters Vlaanderen UI API Key."
  value       = var.ui_key
}

resource "aws_api_gateway_usage_plan_key" "gw-ui-key" {
  key_id        = aws_api_gateway_api_key.gw-ui-key.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.gw-ui.id
}

resource "aws_api_gateway_api_key" "gw-test-key" {
  name        = "${var.api_name}-test"
  description = "Basisregisters Vlaanderen Testing API Key."
  value       = var.test_key
}

resource "aws_api_gateway_usage_plan_key" "gw-test-key" {
  key_id        = aws_api_gateway_api_key.gw-test-key.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.gw-test.id
}
