provider "archive" {
  version = "~> 1.2.2"
}

data "archive_file" "api-auth" {
  type        = "zip"
  source_dir  = "${path.module}/lambda"
  output_path = "${path.module}/apiAuth.zip"
}

resource "aws_lambda_function" "api-auth" {
  depends_on = [data.archive_file.api-auth]

  function_name = "api-auth"
  description   = "Custom API Gateway Authorizer to support Anonymous API Keys"

  runtime = "nodejs8.10"
  handler = "apiAuth.handler"

  role    = aws_iam_role.api-auth.arn
  timeout = 45

  filename         = data.archive_file.api-auth.output_path
  source_code_hash = data.archive_file.api-auth.output_base64sha256

  environment {
    variables = {
      APIKEY = var.anon_key
    }
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

resource "aws_iam_role" "api-auth" {
  name               = "apiAuth"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "api-auth" {
  statement {
    sid    = "CloudwatchLogs"
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:GetLogEvents",
      "logs:PutLogEvents",
    ]

    resources = ["arn:aws:logs:*:*:*"]
  }
}

resource "aws_iam_role_policy" "api-auth" {
  name   = "apiAuth"
  role   = aws_iam_role.api-auth.id
  policy = data.aws_iam_policy_document.api-auth.json
}

resource "aws_iam_role" "invocation_role" {
  name = "api_gateway_auth_invocation"
  path = "/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

resource "aws_iam_role_policy" "invocation_policy" {
  name = "default"
  role = aws_iam_role.invocation_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "lambda:InvokeFunction",
      "Effect": "Allow",
      "Resource": "${aws_lambda_function.api-auth.arn}"
    }
  ]
}
EOF

}
