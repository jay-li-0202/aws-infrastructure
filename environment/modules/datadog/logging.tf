data "archive_file" "logging" {
  type        = "zip"
  source_file = "${path.module}/logging/index.py"
  output_path = "${path.module}/logging.zip"
}

resource "aws_iam_role" "logging-lambda" {
  name = "logging-lambda"

  description        = "Allows Lambda to send logs to Datadog"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  tags = {
    Name        = "Datadog Logging // ${var.environment_label} ${var.environment_name}"
    Environment = var.tag_environment
    Productcode = var.tag_product
    Programma   = var.tag_program
    Contact     = var.tag_contact
  }
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "logging-lambda" {
  statement {
    sid       = "PassRole"
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "iam:PassRole",
    ]
  }

  statement {
    sid       = "ReadS3"
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "s3:Get*",
      "s3:List*",
    ]
  }
}

resource "aws_iam_role_policy" "logging-lambda" {
  name   = "logging-lambda"
  role   = aws_iam_role.logging-lambda.id
  policy = data.aws_iam_policy_document.logging-lambda.json
}

resource "aws_lambda_function" "logging" {
  depends_on = [data.archive_file.logging]

  function_name = "logging"
  description   = "Forwards logs to Datadog."
  runtime       = "python2.7"
  handler       = "index.lambda_handler"

  role        = aws_iam_role.logging-lambda.arn
  timeout     = 120
  memory_size = 1024

  filename         = data.archive_file.logging.output_path
  source_code_hash = data.archive_file.logging.output_base64sha256

  tags = {
    Name        = "Datadog Logging // ${var.environment_label} ${var.environment_name}"
    Environment = var.tag_environment
    Productcode = var.tag_product
    Programma   = var.tag_program
    Contact     = var.tag_contact
  }

  environment {
    variables = {
      DD_API_KEY = var.datadog_api_key
    }
  }
}

