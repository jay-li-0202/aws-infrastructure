resource "aws_lambda_permission" "create-bastion-api" {
  statement_id  = "AllowCreateBastionInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.create-bastion.arn}"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_deployment.bastions.execution_arn}/*/create"
}

resource "aws_api_gateway_resource" "create-bastion" {
  rest_api_id = "${aws_api_gateway_rest_api.bastions.id}"
  parent_id   = "${aws_api_gateway_rest_api.bastions.root_resource_id}"
  path_part   = "create"
}

resource "aws_api_gateway_method" "create-bastion" {
  rest_api_id   = "${aws_api_gateway_rest_api.bastions.id}"
  resource_id   = "${aws_api_gateway_resource.create-bastion.id}"
  http_method   = "POST"
  authorization = "NONE"
  api_key_required  = true
  request_validator_id = "${aws_api_gateway_request_validator.bastions.id}"

  request_parameters = {
    "method.request.querystring.user" = true
  }
}

resource "aws_api_gateway_integration" "create-bastion" {
  rest_api_id = "${aws_api_gateway_rest_api.bastions.id}"
  resource_id = "${aws_api_gateway_method.create-bastion.resource_id}"
  http_method = "${aws_api_gateway_method.create-bastion.http_method}"

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.create-bastion.invoke_arn}"
}
