resource "aws_route53_record" "organisation-api" {
  zone_id = var.public_zone_id
  name    = "organisatie-api"
  type    = "A"

  alias {
    name                   = aws_lb.api.dns_name
    zone_id                = aws_lb.api.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "organisation-ui" {
  zone_id = var.public_zone_id
  name    = "organisatie"
  type    = "CNAME"
  ttl     = "60"
  records = ["organisatie-api.${var.public_zone_name}"]
}

resource "aws_route53_record" "projections-api" {
  zone_id = var.public_zone_id
  name    = "organisation-projections.ops-api"
  type    = "CNAME"
  ttl     = "60"
  records = ["ops-api.${var.public_zone_name}"]
}
