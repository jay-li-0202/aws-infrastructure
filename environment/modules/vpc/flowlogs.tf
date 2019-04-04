resource "aws_cloudwatch_log_group" "vpc_log_group" {
  name              = "${lower(replace(var.environment_label, " ", "-"))}-${lower(replace(var.environment_name, " ", "-"))}-vpc-flow-logs"
  retention_in_days = "${var.log_group_retention_in_days}"
}

resource "aws_iam_role" "vpc_role" {
  name               = "${replace(var.environment_label, " ", "-")}-${replace(var.environment_name, " ", "-")}-VPCFlowLogs"
  description        = "Allows VPC to log to CloudWatch."
  assume_role_policy = "${data.aws_iam_policy_document.flow_log_assume_role.json}"
}

data "aws_iam_policy_document" "flow_log_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "flow_log" {
  statement {
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "iam:PassRole",
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

resource "aws_iam_role_policy" "vpc_role_policy" {
  name   = "${replace(var.environment_label, " ", "-")}-${replace(var.environment_name, " ", "-")}-FlowLogs"
  role   = "${aws_iam_role.vpc_role.id}"
  policy = "${data.aws_iam_policy_document.flow_log.json}"
}

resource "aws_flow_log" "vpc_flow_log" {
  log_destination = "${aws_cloudwatch_log_group.vpc_log_group.arn}"
  iam_role_arn    = "${aws_iam_role.vpc_role.arn}"
  vpc_id          = "${aws_vpc.vpc.id}"
  traffic_type    = "ALL"
}
