resource "aws_iam_role" "rds" {
  name               = "${lower(replace(var.environment_label, " ", "-"))}-${lower(replace(var.environment_name, " ", "-"))}-rds-logs"
  description        = "Allows RDS to log to CloudWatch."
  assume_role_policy = "${data.aws_iam_policy_document.rds_assume_role.json}"

  tags {
    Name        = "RDS Logs // ${var.environment_label} ${var.environment_name}"
    Environment = "${var.tag_environment}"
    Productcode = "${var.tag_product}"
    Programma   = "${var.tag_program}"
    Contact     = "${var.tag_contact}"
  }
}

data "aws_iam_policy_document" "rds_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "rds" {
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

resource "aws_iam_role_policy" "rds_role_policy" {
  name   = "${lower(replace(var.environment_label, " ", "-"))}-${lower(replace(var.environment_name, " ", "-"))}-rds"
  role   = "${aws_iam_role.rds.id}"
  policy = "${data.aws_iam_policy_document.rds.json}"
}
