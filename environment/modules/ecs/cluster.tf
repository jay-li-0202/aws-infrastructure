resource "aws_ecs_cluster" "basisregisters" {
  name = "basisregisters-${lower(replace(var.environment_name, " ", "-"))}"

  tags = {
    Name        = "ECS Cluster // ${var.environment_label} ${var.environment_name}"
    Environment = var.tag_environment
    Productcode = var.tag_product
    Programma   = var.tag_program
    Contact     = var.tag_contact
  }
}

# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_execution_IAM_role.html
resource "aws_iam_role" "ecs-task" {
  name               = "ecs-${lower(replace(var.environment_label, " ", "-"))}-${lower(replace(var.environment_name, " ", "-"))}"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json

  tags = {
    Name        = "ECS Task Execution // ${var.environment_label} ${var.environment_name}"
    Environment = var.tag_environment
    Productcode = var.tag_product
    Programma   = var.tag_program
    Contact     = var.tag_contact
  }
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecs-taskpolicy" {
  role       = aws_iam_role.ecs-task.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_policy_document" "ecs-task" {
  statement {
    sid       = "AllowSecretsManager"
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "secretsmanager:GetSecretValue",
    ]
  }
}

resource "aws_iam_role_policy" "ecs-task" {
  name   = "ecs-task"
  role   = aws_iam_role.ecs-task.id
  policy = data.aws_iam_policy_document.ecs-task.json
}

