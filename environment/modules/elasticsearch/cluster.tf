resource "aws_elasticsearch_domain" "es" {
  domain_name           = lower(substr(var.domain_name, 0, min(28, length(var.domain_name))))
  elasticsearch_version = var.elasticsearch_version
  access_policies       = data.aws_iam_policy_document.es.json

  cluster_config {
    instance_type            = var.data_instance_type
    instance_count           = var.data_instance_count
    dedicated_master_enabled = var.master_enabled
    dedicated_master_type    = var.master_instance_type
    dedicated_master_count   = var.master_instance_count
    zone_awareness_enabled   = true
  }

  vpc_options {
    security_group_ids = [aws_security_group.elasticsearch.id]
    subnet_ids         = var.subnet_ids
  }

  advanced_options = {
    "rest.action.multi.allow_explicit_index" = "true"
  }

  log_publishing_options {
    log_type                 = "INDEX_SLOW_LOGS"
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.es_index_log_group.arn
  }

  log_publishing_options {
    log_type                 = "SEARCH_SLOW_LOGS"
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.es_search_log_group.arn
  }

  snapshot_options {
    automated_snapshot_start_hour = 23
  }

  ebs_options {
    ebs_enabled = true
    volume_type = var.volume_type // General Purpose SSD
    volume_size = var.volume_size // https://docs.aws.amazon.com/elasticsearch-service/latest/developerguide/aes-limits.html
  }

  tags = {
    Name             = "Elasticsearch // ${var.environment_label} ${var.environment_name}"
    Domain           = var.domain_name
    DomainNormalized = lower(substr(var.domain_name, 0, min(28, length(var.domain_name))))
    Environment      = var.tag_environment
    Productcode      = var.tag_product
    Programma        = var.tag_program
    Contact          = var.tag_contact
  }
}

data "aws_iam_policy_document" "es" {
  statement {
    sid     = "UseSecurityGroups"
    effect  = "Allow"
    actions = ["es:*"]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    resources = [
      "arn:aws:es:*:*:domain/${lower(substr(var.domain_name, 0, min(28, length(var.domain_name))))}/*",
    ]
  }
}
