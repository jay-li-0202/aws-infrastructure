resource "aws_wafregional_byte_match_set" "api_key" {
  name = "api_key_in_header"

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
  metric_name = "apikey"

  // https://github.com/terraform-providers/terraform-provider-aws/pull/9946
  rate_limit = 2000
  rate_key   = "IP"

  predicate {
    data_id = "${aws_wafregional_byte_match_set.api_key.id}"
    negated = true
    type    = "ByteMatch"
  }
}

resource "aws_wafregional_web_acl" "api_key" {
  name        = "missing-api-key"
  metric_name = "apikey"

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

resource "aws_wafregional_web_acl_association" "api_key" {
  resource_arn = "arn:aws:apigateway:${var.region}::/restapis/${aws_api_gateway_rest_api.gw.id}/stages/${var.api_stage_name}"
  web_acl_id   = "${aws_wafregional_web_acl.api_key.id}"
}
