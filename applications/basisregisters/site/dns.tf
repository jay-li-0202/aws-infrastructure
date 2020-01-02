resource "aws_route53_record" "site" {
  zone_id = var.public_zone_id
  name    = ""
  type    = "A"

  alias {
    name                   = aws_lb.main.dns_name
    zone_id                = aws_lb.main.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "www" {
  zone_id = var.public_zone_id
  name    = "www"
  type    = "CNAME"
  ttl     = "60"
  records = [var.public_zone_name]
}
