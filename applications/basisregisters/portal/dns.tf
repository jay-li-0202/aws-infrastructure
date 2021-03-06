resource "aws_route53_record" "portal" {
  zone_id = var.public_zone_id
  name    = "portal"
  type    = "CNAME"
  ttl     = "60"
  records = [var.portal_fqdn]
}

resource "aws_route53_record" "auth" {
  zone_id = var.public_zone_id
  name    = "auth"
  type    = "CNAME"
  ttl     = "60"
  records = [var.auth_fqdn]
}
