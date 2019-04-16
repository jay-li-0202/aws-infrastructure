resource "aws_api_gateway_rest_api" "bastions" {
  name                     = "bastions-api"
  description              = "Bastions API // ${var.environment_label} ${var.environment_name}"
  api_key_source           = "HEADER"
  minimum_compression_size = 0
}

resource "aws_api_gateway_deployment" "bastions" {
  depends_on = [
    "aws_api_gateway_integration.create-bastion",
  ]

  rest_api_id = "${aws_api_gateway_rest_api.bastions.id}"
  description = "Bastions API // ${var.environment_label} ${var.environment_name}"
  stage_name  = "bastions-${lower(var.environment_name)}"

  stage_description = <<EOF
${md5("
  ${file("${path.module}/api.tf")}
  ${file("${path.module}/create-bastion.tf")}
  ${file("${path.module}/create-bastion/index.py")}
  ${file("${path.module}/delete-bastion.tf")}
  ${file("${path.module}/delete-bastion/index.py")}
  ${file("${path.module}/delete-all-bastions.tf")}
  ${file("${path.module}/delete-all-bastions/index.py")}
")}
EOF

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
    stage  = "${aws_api_gateway_deployment.bastions.stage_name}"
  }
}

resource "aws_api_gateway_api_key" "bastions" {
  name        = "bastions"
  description = "Bastions API // ${var.environment_label} ${var.environment_name}"
}

resource "aws_api_gateway_usage_plan_key" "bastions" {
  key_id        = "${aws_api_gateway_api_key.bastions.id}"
  key_type      = "API_KEY"
  usage_plan_id = "${aws_api_gateway_usage_plan.bastions.id}"
}
