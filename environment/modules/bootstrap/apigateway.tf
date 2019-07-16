resource "aws_api_gateway_account" "basisregisters" {
  cloudwatch_role_arn = "${aws_iam_role.api_gateway.arn}"
}

resource "aws_iam_role" "api_gateway" {
  name               = "${lower(replace(var.environment_label, " ", "-"))}-${lower(replace(var.environment_name, " ", "-"))}-api-gateway-logs"
  description        = "Allows Api Gateway to log to CloudWatch."
  assume_role_policy = "${data.aws_iam_policy_document.api_gateway_assume_role.json}"

  tags = {
    Name        = "Api Gateway Logs // ${var.environment_label} ${var.environment_name}"
    Environment = "${var.tag_environment}"
    Productcode = "${var.tag_product}"
    Programma   = "${var.tag_program}"
    Contact     = "${var.tag_contact}"
  }
}

data "aws_iam_policy_document" "api_gateway_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["apigateway.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "api_gateway" {
  statement {
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
      "logs:PutLogEvents",
      "logs:GetLogEvents",
      "logs:FilterLogEvents",
      "logs:PutRetentionPolicy",
    ]
  }
}

resource "aws_iam_role_policy" "api_gateway_role_policy" {
  name   = "${lower(replace(var.environment_label, " ", "-"))}-${lower(replace(var.environment_name, " ", "-"))}-api-gateway"
  role   = "${aws_iam_role.api_gateway.id}"
  policy = "${data.aws_iam_policy_document.api_gateway.json}"
}
