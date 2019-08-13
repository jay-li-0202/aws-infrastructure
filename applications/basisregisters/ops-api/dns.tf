resource "aws_route53_record" "ops-api" {
  zone_id = var.public_zone_id
  name    = "ops-api"
  type    = "A"

  alias {
    name                   = aws_lb.main.dns_name
    zone_id                = aws_lb.main.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "dev-api" {
  zone_id = var.public_zone_id
  name    = "dev-api"
  type    = "CNAME"
  ttl     = "60"
  records = ["ops-api.${var.public_zone_name}"]
}
