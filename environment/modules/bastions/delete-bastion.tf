data "archive_file" "delete-bastion" {
  type        = "zip"
  source_file = "${path.module}/delete-bastion/index.py"
  output_path = "${path.module}/delete-bastion.zip"
}

resource "aws_iam_role" "delete-bastions-lambda" {
  name = "delete-bastions-lambda"

  description        = "Allows Lambda to delete Bastions"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  tags = {
    Name        = "Delete Bastion Host // ${var.environment_label} ${var.environment_name}"
    Environment = var.tag_environment
    Productcode = var.tag_product
    Programma   = var.tag_program
    Contact     = var.tag_contact
  }
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
  role   = aws_iam_role.delete-bastions-lambda.id
  policy = data.aws_iam_policy_document.delete-bastions-lambda.json
}

resource "aws_lambda_function" "delete-bastion" {
  depends_on = [data.archive_file.delete-bastion]

  function_name = "delete-bastion"
  description   = "Deletes a bastion server."
  runtime       = "python2.7"
  handler       = "index.lambda_handler"

  role    = aws_iam_role.delete-bastions-lambda.arn
  timeout = 900

  filename         = data.archive_file.delete-bastion.output_path
  source_code_hash = data.archive_file.delete-bastion.output_base64sha256

  tags = {
    Name        = "Delete Bastion // ${var.environment_label} ${var.environment_name}"
    Environment = var.tag_environment
    Productcode = var.tag_product
    Programma   = var.tag_program
    Contact     = var.tag_contact
  }

  environment {
    variables = {
      BASTION_CLUSTER = var.bastion_cluster
      BASTION_VPC     = var.bastion_vpc
      BASTION_SUFFIX  = "-${lower(replace(var.environment_name, " ", "-"))}-bastion"
    }
  }
}

