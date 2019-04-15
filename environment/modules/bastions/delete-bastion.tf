resource "aws_lambda_permission" "delete-bastion-api" {
  statement_id  = "AllowDeleteBastionInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.delete-bastion.arn}"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_deployment.bastions.execution_arn}/*/bastion"
}

resource "aws_api_gateway_resource" "delete-bastion" {
  rest_api_id = "${aws_api_gateway_rest_api.bastions.id}"
  parent_id   = "${aws_api_gateway_rest_api.bastions.root_resource_id}"
  path_part   = "bastion"
}

resource "aws_api_gateway_method" "delete-bastion" {
  rest_api_id          = "${aws_api_gateway_rest_api.bastions.id}"
  resource_id          = "${aws_api_gateway_resource.delete-bastion.id}"
  http_method          = "DELETE"
  authorization        = "NONE"
  api_key_required     = true
  request_validator_id = "${aws_api_gateway_request_validator.bastions.id}"

  request_parameters = {
    "method.request.querystring.user" = true
  }
}

resource "aws_api_gateway_integration" "delete-bastion" {
  rest_api_id = "${aws_api_gateway_rest_api.bastions.id}"
  resource_id = "${aws_api_gateway_method.delete-bastion.resource_id}"
  http_method = "${aws_api_gateway_method.delete-bastion.http_method}"

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.delete-bastion.invoke_arn}"
}

data "archive_file" "delete-bastion" {
  type        = "zip"
  source_file = "${path.module}/delete-bastion/index.py"
  output_path = "${path.module}/delete-bastion.zip"
}

resource "aws_iam_role" "delete-bastions-lambda" {
  name = "delete-bastions-lambda"

  description        = "Allows Lambda to delete Bastions"
  assume_role_policy = "${data.aws_iam_policy_document.assume_role.json}"
}

data "aws_iam_policy_document" "delete-bastions-lambda" {
  statement {
    sid       = "Ec2"
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "ec2:DeleteSecurityGroup",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DescribeSecurityGroups",
    ]
  }

  statement {
    sid       = "RunEcs"
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "ecs:StopTask",
      "ecs:ListTask*",
      "ecs:DescribeTask*",
    ]
  }
}

resource "aws_iam_role_policy" "delete-bastions-lambda" {
  name   = "delete-bastions-lambda"
  role   = "${aws_iam_role.delete-bastions-lambda.id}"
  policy = "${data.aws_iam_policy_document.delete-bastions-lambda.json}"
}

resource "aws_lambda_function" "delete-bastion" {
  depends_on = ["data.archive_file.delete-bastion"]

  function_name = "delete-bastion"
  description   = "Deletes a bastion server."
  runtime       = "python2.7"
  handler       = "index.lambda_handler"

  role    = "${aws_iam_role.delete-bastions-lambda.arn}"
  timeout = 30

  filename         = "${data.archive_file.delete-bastion.output_path}"
  source_code_hash = "${data.archive_file.delete-bastion.output_base64sha256}"

  tags {
    Name        = "Delete Bastion // ${var.environment_label} ${var.environment_name}"
    Environment = "${var.tag_environment}"
    Productcode = "${var.tag_product}"
    Programma   = "${var.tag_program}"
    Contact     = "${var.tag_contact}"
  }

  environment {
    variables = {
      BASTION_CLUSTER = "${var.bastion_cluster}"
      BASTION_VPC     = "${var.bastion_vpc}"
    }
  }
}
