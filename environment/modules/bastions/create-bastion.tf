resource "aws_lambda_permission" "create-bastion-api" {
  statement_id  = "AllowCreateBastionInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.create-bastion.arn}"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.bastions.execution_arn}/*/POST/bastion"
}

resource "aws_api_gateway_resource" "create-bastion" {
  rest_api_id = "${aws_api_gateway_rest_api.bastions.id}"
  parent_id   = "${aws_api_gateway_rest_api.bastions.root_resource_id}"
  path_part   = "bastion"
}

resource "aws_api_gateway_method" "create-bastion" {
  rest_api_id          = "${aws_api_gateway_rest_api.bastions.id}"
  resource_id          = "${aws_api_gateway_resource.create-bastion.id}"
  http_method          = "POST"
  authorization        = "NONE"
  api_key_required     = true
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

data "archive_file" "create-bastion" {
  type        = "zip"
  source_file = "${path.module}/create-bastion/index.py"
  output_path = "${path.module}/create-bastion.zip"
}

resource "aws_iam_role" "create-bastions-lambda" {
  name = "create-bastions-lambda"

  description        = "Allows Lambda to create Bastions"
  assume_role_policy = "${data.aws_iam_policy_document.assume_role.json}"

  tags = {
    Name        = "Create Bastion Host // ${var.environment_label} ${var.environment_name}"
    Environment = "${var.tag_environment}"
    Productcode = "${var.tag_product}"
    Programma   = "${var.tag_program}"
    Contact     = "${var.tag_contact}"
  }
}

data "aws_iam_policy_document" "create-bastions-lambda" {
  statement {
    sid       = "Ec2"
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "ec2:DescribeNetworkInterfaces",
      "ec2:DescribeSecurityGroups",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:CreateSecurityGroup",
      "ec2:CreateTags",
    ]
  }

  statement {
    sid       = "PassRole"
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "iam:PassRole",
    ]
  }

  statement {
    sid       = "RunEcs"
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "ecs:RunTask",
      "ecs:ListTask*",
      "ecs:DescribeTask*",
    ]
  }
}

resource "aws_iam_role_policy" "create-bastions-lambda" {
  name   = "bastions-lambda"
  role   = "${aws_iam_role.create-bastions-lambda.id}"
  policy = "${data.aws_iam_policy_document.create-bastions-lambda.json}"
}

resource "aws_lambda_function" "create-bastion" {
  depends_on = ["data.archive_file.create-bastion"]

  function_name = "create-bastion"
  description   = "Creates a bastion server."
  runtime       = "python2.7"
  handler       = "index.lambda_handler"

  role    = "${aws_iam_role.create-bastions-lambda.arn}"
  timeout = 30

  filename         = "${data.archive_file.create-bastion.output_path}"
  source_code_hash = "${data.archive_file.create-bastion.output_base64sha256}"

  tags = {
    Name        = "Create Bastion // ${var.environment_label} ${var.environment_name}"
    Environment = "${var.tag_environment}"
    Productcode = "${var.tag_product}"
    Programma   = "${var.tag_program}"
    Contact     = "${var.tag_contact}"
  }

  environment {
    variables = {
      BASTION_CLUSTER        = "${var.bastion_cluster}"
      BASTION_SUBNETS        = "${join(",", var.bastion_subnets)}"
      BASTION_VPC            = "${var.bastion_vpc}"
      BASTION_SUFFIX         = "-${lower(replace(var.environment_name, " ", "-"))}-bastion"
      BASTION_SECURITY_GROUP = "${aws_security_group.bastion.id}"

      TAG_NameSuffix  = " // ${var.environment_label} ${var.environment_name}"
      TAG_Environment = "${var.tag_environment}"
      TAG_Productcode = "${var.tag_product}"
      TAG_Programma   = "${var.tag_program}"
      TAG_Contact     = "${var.tag_contact}"
    }
  }
}
