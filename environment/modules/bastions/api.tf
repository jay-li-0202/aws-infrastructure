resource "aws_api_gateway_rest_api" "bastions" {
  name                     = "bastions-api"
  description              = "Bastions Api // ${var.environment_label} ${var.environment_name}"
  api_key_source           = "HEADER"
  minimum_compression_size = 0
}

resource "aws_api_gateway_deployment" "bastions" {
  depends_on = [
    "aws_api_gateway_integration.create-bastion",
    "aws_api_gateway_integration.delete-bastion",
    "aws_api_gateway_integration.delete-all-bastions",
  ]

  rest_api_id = "${aws_api_gateway_rest_api.bastions.id}"
  description = "Bastions Api // ${var.environment_label} ${var.environment_name}"
  stage_name  = ""

  stage_description = "${md5("${file("${path.module}/api.tf")}\n${file("${path.module}/create-bastion.tf")}\n${file("${path.module}/create-bastion/index.py")}\n${file("${path.module}/delete-bastion.tf")}\n${file("${path.module}/delete-bastion/index.py")}\n${file("${path.module}/delete-all-bastions.tf")}\n${file("${path.module}/delete-all-bastions/index.py")}\n")}"

  //   stage_description = <<EOF
  // ${md5("
  //   ${file("${path.module}/api.tf")}
  //   ${file("${path.module}/create-bastion.tf")}
  //   ${file("${path.module}/create-bastion/index.py")}
  //   ${file("${path.module}/delete-bastion.tf")}
  //   ${file("${path.module}/delete-bastion/index.py")}
  //   ${file("${path.module}/delete-all-bastions.tf")}
  //   ${file("${path.module}/delete-all-bastions/index.py")}
  // ")}
  // EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_request_validator" "bastions" {
  name                        = "bastions-api"
  rest_api_id                 = "${aws_api_gateway_rest_api.bastions.id}"
  validate_request_body       = false
  validate_request_parameters = true
}

resource "aws_api_gateway_usage_plan" "bastions" {
  name = "bastions-api"

  api_stages {
    api_id = "${aws_api_gateway_rest_api.bastions.id}"
    stage  = "${aws_api_gateway_stage.bastions.stage_name}"
  }
}

resource "aws_api_gateway_api_key" "bastions" {
  name        = "bastions"
  description = "Bastions Api // ${var.environment_label} ${var.environment_name}"
}

resource "aws_api_gateway_usage_plan_key" "bastions" {
  key_id        = "${aws_api_gateway_api_key.bastions.id}"
  key_type      = "API_KEY"
  usage_plan_id = "${aws_api_gateway_usage_plan.bastions.id}"
}

resource "aws_api_gateway_stage" "bastions" {
  rest_api_id   = "${aws_api_gateway_rest_api.bastions.id}"
  stage_name    = "bastions-${lower(var.environment_name)}"
  deployment_id = "${aws_api_gateway_deployment.bastions.id}"
  description   = "Bastions Api // ${var.environment_label} ${var.environment_name}"

  access_log_settings {
    destination_arn = "${aws_cloudwatch_log_group.bastions.arn}"
    format          = "{ \"requestId\":\"$context.requestId\", \"ip\":\"$context.identity.sourceIp\", \"caller\":\"$context.identity.caller\", \"user\":\"$context.identity.user\", \"requestTime\":$context.requestTimeEpoch, \"httpMethod\":\"$context.httpMethod\", \"resourcePath\":\"$context.resourcePath\", \"status\":$context.status, \"protocol\":\"$context.protocol\", \"responseLength\":$context.responseLength }"
  }

  tags {
    Name        = "Bastions Api // ${var.environment_label} ${var.environment_name}"
    Environment = "${var.tag_environment}"
    Productcode = "${var.tag_product}"
    Programma   = "${var.tag_program}"
    Contact     = "${var.tag_contact}"
  }
}

resource "aws_api_gateway_method_settings" "bastions" {
  rest_api_id = "${aws_api_gateway_rest_api.bastions.id}"
  stage_name  = "${aws_api_gateway_stage.bastions.stage_name}"
  method_path = "*/*"

  settings {
    metrics_enabled    = true
    logging_level      = "INFO"
    data_trace_enabled = true

    // https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-request-throttling.html
    throttling_rate_limit  = 10000
    throttling_burst_limit = 5000
  }
}

resource "aws_cloudwatch_log_group" "bastions" {
  name              = "/apigateway/bastions-${lower(var.environment_name)}"
  retention_in_days = 30

  tags {
    Name        = "Bastions Api Gateway // ${var.environment_label} ${var.environment_name}"
    Environment = "${var.tag_environment}"
    Productcode = "${var.tag_product}"
    Programma   = "${var.tag_program}"
    Contact     = "${var.tag_contact}"
  }
}

resource "aws_cloudwatch_log_stream" "app_log_stream" {
  name           = "bastions-${lower(var.environment_name)}"
  log_group_name = "${aws_cloudwatch_log_group.bastions.name}"
}

resource "aws_lambda_permission" "app_log" {
  statement_id  = "bastions-${lower(var.environment_name)}"
  action        = "lambda:InvokeFunction"
  function_name = "${var.datadog_logging_lambda}"
  principal     = "logs.eu-west-1.amazonaws.com"
  source_arn    = "${aws_cloudwatch_log_group.bastions.arn}"
}

resource "aws_cloudwatch_log_subscription_filter" "app_logfilter" {
  name            = "bastions-${lower(var.environment_name)}"
  log_group_name  = "${aws_cloudwatch_log_group.bastions.name}"
  destination_arn = "${var.datadog_logging_lambda}"
  filter_pattern  = ""
}
