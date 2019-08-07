resource "aws_route53_record" "public-api" {
  zone_id = var.public_zone_id
  name    = "public-api"
  type    = "A"

  alias {
    name                   = aws_lb.api.dns_name
    zone_id                = aws_lb.api.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "legacy-api" {
  zone_id = var.public_zone_id
  name    = "legacy-api"
  type    = "CNAME"
  ttl     = "60"
  records = ["public-api.${var.public_zone_name}"]
}

resource "aws_route53_record" "docs" {
  zone_id = var.public_zone_id
  name    = "docs"
  type    = "CNAME"
  ttl     = "60"
  records = ["public-api.${var.public_zone_name}"]
}

