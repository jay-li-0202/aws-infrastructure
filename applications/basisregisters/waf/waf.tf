resource "aws_wafregional_byte_match_set" "api_key" {
  name = "api-key"

  byte_match_tuples {
    text_transformation   = "NONE"
    target_string         = "-"
    positional_constraint = "CONTAINS"

    field_to_match {
      type = "HEADER"
      data = "x-api-key"
    }
  }

  byte_match_tuples {
    text_transformation   = "NONE"
    target_string         = "-"
    positional_constraint = "CONTAINS"

    field_to_match {
      type = "SINGLE_QUERY_ARG"
      data = "x-api-key"
    }
  }
}

resource "aws_wafregional_rate_based_rule" "api_key" {
  depends_on  = ["aws_wafregional_byte_match_set.api_key"]
  name        = "missing-api-key"
  metric_name = "MissingApiKey"

  rate_limit = var.api_anonymous_rate_limit_per_5min
  rate_key   = "IP"

  predicate {
    data_id = "${aws_wafregional_byte_match_set.api_key.id}"
    negated = true
    type    = "ByteMatch"
  }
}

resource "aws_wafregional_web_acl" "api_key" {
  name        = "anonymous-user"
  metric_name = "anonymous"

  default_action {
    type = "ALLOW"
  }

  rule {
    action {
      type = "BLOCK"
    }

    priority = 1
    rule_id  = "${aws_wafregional_rate_based_rule.api_key.id}"
    type     = "RATE_BASED"
  }
}
