resource "aws_api_gateway_domain_name" "gw" {
  domain_name = "${var.api_url}.${replace(var.public_zone_name, "/[.]$/", "")}"

  certificate_arn = aws_acm_certificate.cert.arn
  security_policy = "TLS_1_2"
}

resource "aws_api_gateway_domain_name" "gw_alias" {
  domain_name = "${var.api_url}.${replace(var.alias_zone_name, "/[.]$/", "")}"

  certificate_arn = aws_acm_certificate.cert.arn
  security_policy = "TLS_1_2"
}

data "aws_route53_zone" "gw_zone" {
  name         = var.public_zone_name
  private_zone = false
}

data "aws_route53_zone" "gw_zone_alias" {
  name         = var.alias_zone_name
  private_zone = false
}

resource "aws_route53_record" "gw_record" {
  zone_id = data.aws_route53_zone.gw_zone.id

  name = aws_api_gateway_domain_name.gw.domain_name
  type = "A"

  alias {
    name                   = aws_api_gateway_domain_name.gw.cloudfront_domain_name
    zone_id                = aws_api_gateway_domain_name.gw.cloudfront_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "gw_record_alias" {
  zone_id = data.aws_route53_zone.gw_zone_alias.id

  name = aws_api_gateway_domain_name.gw_alias.domain_name
  type = "A"

  alias {
    name                   = aws_api_gateway_domain_name.gw_alias.cloudfront_domain_name
    zone_id                = aws_api_gateway_domain_name.gw_alias.cloudfront_zone_id
    evaluate_target_health = true
  }
}
