resource "aws_cloudwatch_log_group" "es_index_log_group" {
  name              = "${lower(replace(var.environment_label, " ", "-"))}-${lower(replace(var.environment_name, " ", "-"))}-elasticsearch-index-slow-logs"
  retention_in_days = var.log_group_retention_in_days

  tags = {
    Name        = "Elasticsearch Index Slow Logs // ${var.environment_label} ${var.environment_name}"
    Environment = var.tag_environment
    Productcode = var.tag_product
    Programma   = var.tag_program
    Contact     = var.tag_contact
  }
}

resource "aws_cloudwatch_log_group" "es_search_log_group" {
  name              = "${lower(replace(var.environment_label, " ", "-"))}-${lower(replace(var.environment_name, " ", "-"))}-elasticsearch-search-slow-logs"
  retention_in_days = var.log_group_retention_in_days

  tags = {
    Name        = "Elasticsearch Search Slow Logs // ${var.environment_label} ${var.environment_name}"
    Environment = var.tag_environment
    Productcode = var.tag_product
    Programma   = var.tag_program
    Contact     = var.tag_contact
  }
}

data "aws_iam_policy_document" "es-logging-policy" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      "arn:aws:logs:*:*:${aws_cloudwatch_log_group.es_index_log_group.name}:*",
      "arn:aws:logs:*:*:${aws_cloudwatch_log_group.es_search_log_group.name}:*",
    ]

    principals {
      identifiers = ["es.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_cloudwatch_log_resource_policy" "es-logging-policy" {
  policy_document = data.aws_iam_policy_document.es-logging-policy.json
  policy_name     = "${lower(replace(var.environment_label, " ", "-"))}-${lower(replace(var.environment_name, " ", "-"))}-es-logging-policy"
}

