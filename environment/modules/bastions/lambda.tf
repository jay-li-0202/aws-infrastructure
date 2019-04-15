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

resource "aws_iam_role" "bastions-lambda" {
  name = "bastions-lambda"

  description        = "Allows Lambda to create Bastions"
  assume_role_policy = "${data.aws_iam_policy_document.assume_role.json}"
}

data "aws_iam_policy_document" "bastions-lambda" {
  statement {
    sid    = "Ec2"
    effect = "Allow"
    resources = ["*"]

    actions = [
      "ec2:DescribeNetworkInterfaces",
      "ec2:DescribeSecurityGroups",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:CreateSecurityGroup",
      "ec2:CreateTags"
    ]
  }

  statement {
    sid       = "PassRole"
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "iam:PassRole"
    ]
  }

  statement {
    sid       = "RunEcs"
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "ecs:RunTask",
      "ecs:ListTask*",
      "ecs:DescribeTask*"
    ]
  }
}

resource "aws_iam_role_policy" "bastions-lambda" {
  name   = "bastions-lambda"
  role   = "${aws_iam_role.bastions-lambda.id}"
  policy = "${data.aws_iam_policy_document.bastions-lambda.json}"
}
