resource "aws_iam_role" "ecs_events" {
  name        = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-organisation-registry-ecs-events"
  description = "Allows Cloudwatch to execute Fargate Tasks."

  assume_role_policy = <<DOC
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "events.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
DOC

  tags = {
    Name        = "Cloudwatch Fargate Executor // ${var.environment_label} ${var.environment_name}"
    Environment = var.tag_environment
    Productcode = var.tag_product
    Programma   = var.tag_program
    Contact     = var.tag_contact
  }
}

resource "aws_iam_role_policy" "ecs_events_run_task_with_any_role" {
  name = "ecs_events_run_task_with_any_role"
  role = aws_iam_role.ecs_events.id

  policy = <<DOC
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "iam:PassRole",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "ecs:RunTask",
            "Resource": "${replace(aws_ecs_task_definition.agentschapzorgengezondheidftpdump.arn, "/:\\d+$/", ":*")}"
        },
        {
            "Effect": "Allow",
            "Action": "ecs:RunTask",
            "Resource": "${replace(aws_ecs_task_definition.delegations.arn, "/:\\d+$/", ":*")}"
        },
        {
            "Effect": "Allow",
            "Action": "ecs:RunTask",
            "Resource": "${replace(aws_ecs_task_definition.elasticsearch.arn, "/:\\d+$/", ":*")}"
        },
        {
            "Effect": "Allow",
            "Action": "ecs:RunTask",
            "Resource": "${replace(aws_ecs_task_definition.reporting.arn, "/:\\d+$/", ":*")}"
        },
        {
            "Effect": "Allow",
            "Action": "ecs:RunTask",
            "Resource": "${replace(aws_ecs_task_definition.vlaanderenbe.arn, "/:\\d+$/", ":*")}"
        },
        {
            "Effect": "Allow",
            "Action": "ecs:RunTask",
            "Resource": "${replace(aws_ecs_task_definition.scheduler.arn, "/:\\d+$/", ":*")}"
        }
    ]
}
DOC

}
