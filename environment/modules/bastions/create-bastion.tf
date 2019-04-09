data "archive_file" "create-bastion" {
  type        = "zip"
  source_file = "${path.module}/create-bastion/index.py"
  output_path = "${path.module}/create-bastion.zip"
}

resource "aws_lambda_function" "create-bastion" {
  depends_on       = ["data.archive_file.create-bastion"]

  function_name    = "create-bastion"
  description      = "Creates a bastion server."
  runtime          = "python2.7"
  handler          = "index.lambda_handler"

  role             = "${aws_iam_role.bastions-lambda.arn}"
  timeout          = 30

  filename         = "${data.archive_file.create-bastion.output_path}"
  source_code_hash = "${data.archive_file.create-bastion.output_base64sha256}"

  tags {
    Name        = "Create Bastion // ${var.environment_label} ${var.environment_name}"
    Environment = "${var.tag_environment}"
    Productcode = "${var.tag_product}"
    Programma   = "${var.tag_program}"
    Contact     = "${var.tag_contact}"
  }

  environment {
    variables = {
      BASTION_CLUSTER = "${var.bastion_cluster}"
      BASTION_SUBNETS = "${join(",", var.bastion_subnets)}"
      BASTION_VPC = "${var.bastion_vpc}"
    }
  }
}
