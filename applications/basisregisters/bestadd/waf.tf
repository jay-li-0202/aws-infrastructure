resource "aws_wafregional_web_acl_association" "api_key" {
  resource_arn = "arn:aws:apigateway:${var.region}::/restapis/${aws_api_gateway_rest_api.gw.id}/stages/${var.api_stage_name}"
  web_acl_id   = var.api_anonymous_waf_acl_id
}
