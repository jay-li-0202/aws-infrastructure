resource "aws_lambda_permission" "delete-all-bastions-api" {
  statement_id  = "AllowDeleteAllBastionsInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.delete-all-bastions.arn}"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.bastions.execution_arn}/*/DELETE/bastions"
}

resource "aws_api_gateway_resource" "delete-all-bastions" {
  rest_api_id = "${aws_api_gateway_rest_api.bastions.id}"
  parent_id   = "${aws_api_gateway_rest_api.bastions.root_resource_id}"
  path_part   = "bastions"
}

resource "aws_api_gateway_method" "delete-all-bastions" {
  rest_api_id          = "${aws_api_gateway_rest_api.bastions.id}"
  resource_id          = "${aws_api_gateway_resource.delete-all-bastions.id}"
  http_method          = "DELETE"
  authorization        = "NONE"
  api_key_required     = true
  request_validator_id = "${aws_api_gateway_request_validator.bastions.id}"
}

resource "aws_api_gateway_integration" "delete-all-bastions" {
  rest_api_id = "${aws_api_gateway_rest_api.bastions.id}"
  resource_id = "${aws_api_gateway_method.delete-all-bastions.resource_id}"
  http_method = "${aws_api_gateway_method.delete-all-bastions.http_method}"

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.delete-all-bastions.invoke_arn}"
}

data "archive_file" "delete-all-bastions" {
  type        = "zip"
  source_file = "${path.module}/delete-all-bastions/index.py"
  output_path = "${path.module}/delete-all-bastions.zip"
}

resource "aws_iam_role" "delete-all-bastions-lambda" {
  name = "delete-all-bastions-lambda"

  description        = "Allows Lambda to delete all Bastions"
  assume_role_policy = "${data.aws_iam_policy_document.assume_role.json}"

  tags {
    Name        = "Delete All Bastions Hosts // ${var.environment_label} ${var.environment_name}"
    Environment = "${var.tag_environment}"
    Productcode = "${var.tag_product}"
    Programma   = "${var.tag_program}"
    Contact     = "${var.tag_contact}"
  }
}

data "aws_iam_policy_document" "delete-all-bastions-lambda" {
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

resource "aws_iam_role_policy" "delete-all-bastions-lambda" {
  name   = "delete-all-bastions-lambda"
  role   = "${aws_iam_role.delete-all-bastions-lambda.id}"
  policy = "${data.aws_iam_policy_document.delete-all-bastions-lambda.json}"
}

resource "aws_lambda_function" "delete-all-bastions" {
  depends_on = ["data.archive_file.delete-all-bastions"]

  function_name = "delete-all-bastions"
  description   = "Deletes all bastion servers."
  runtime       = "python2.7"
  handler       = "index.lambda_handler"

  role    = "${aws_iam_role.delete-all-bastions-lambda.arn}"
  timeout = 900

  filename         = "${data.archive_file.delete-all-bastions.output_path}"
  source_code_hash = "${data.archive_file.delete-all-bastions.output_base64sha256}"

  tags {
    Name        = "Delete All Bastions // ${var.environment_label} ${var.environment_name}"
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
