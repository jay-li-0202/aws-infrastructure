resource "aws_lambda_permission" "delete-bastion-api" {
  statement_id  = "AllowDeleteBastionInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.delete-bastion-trigger.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.bastions.execution_arn}/*/DELETE/bastion"
}

resource "aws_api_gateway_resource" "delete-bastion" {
  rest_api_id = aws_api_gateway_rest_api.bastions.id
  parent_id   = aws_api_gateway_rest_api.bastions.root_resource_id
  path_part   = "bastion"
}

resource "aws_api_gateway_method" "delete-bastion" {
  rest_api_id          = aws_api_gateway_rest_api.bastions.id
  resource_id          = aws_api_gateway_resource.delete-bastion.id
  http_method          = "DELETE"
  authorization        = "NONE"
  api_key_required     = true
  request_validator_id = aws_api_gateway_request_validator.bastions.id

  request_parameters = {
    "method.request.querystring.user" = true
  }
}

resource "aws_api_gateway_integration" "delete-bastion" {
  rest_api_id = aws_api_gateway_rest_api.bastions.id
  resource_id = aws_api_gateway_method.delete-bastion.resource_id
  http_method = aws_api_gateway_method.delete-bastion.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.delete-bastion-trigger.invoke_arn
}

data "archive_file" "delete-bastion-trigger" {
  type        = "zip"
  source_file = "${path.module}/delete-bastion-trigger/index.py"
  output_path = "${path.module}/delete-bastion-trigger.zip"
}

resource "aws_iam_role" "delete-bastions-trigger-lambda" {
  name = "delete-bastions-trigger-lambda"

  description        = "Allows Lambda to trigger Lambda to delete Bastions"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  tags = {
    Name        = "Delete Bastion Host Trigger // ${var.environment_label} ${var.environment_name}"
    Environment = var.tag_environment
    Productcode = var.tag_product
    Programma   = var.tag_program
    Contact     = var.tag_contact
  }
}

data "aws_iam_policy_document" "delete-bastions-trigger-lambda" {
  statement {
    sid       = "InvokeLambda"
    effect    = "Allow"
    resources = [aws_lambda_function.delete-bastion.arn]

    actions = [
      "lambda:InvokeFunction",
    ]
  }
}

resource "aws_iam_role_policy" "delete-bastions-trigger-lambda" {
  name   = "delete-bastions-trigger-lambda"
  role   = aws_iam_role.delete-bastions-trigger-lambda.id
  policy = data.aws_iam_policy_document.delete-bastions-trigger-lambda.json
}

resource "aws_lambda_function" "delete-bastion-trigger" {
  depends_on = [data.archive_file.delete-bastion-trigger]

  function_name = "delete-bastion-trigger"
  description   = "Tiggers a Lambda to delete a bastion server."
  runtime       = "python2.7"
  handler       = "index.lambda_handler"

  role    = aws_iam_role.delete-bastions-trigger-lambda.arn
  timeout = 30

  filename         = data.archive_file.delete-bastion-trigger.output_path
  source_code_hash = data.archive_file.delete-bastion-trigger.output_base64sha256

  tags = {
    Name        = "Delete Bastion Trigger // ${var.environment_label} ${var.environment_name}"
    Environment = var.tag_environment
    Productcode = var.tag_product
    Programma   = var.tag_program
    Contact     = var.tag_contact
  }

  environment {
    variables = {
      DELETE_FUNCTION = aws_lambda_function.delete-bastion.arn
    }
  }
}
