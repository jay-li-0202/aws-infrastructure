resource "aws_route53_record" "docs" {
  zone_id = var.public_zone_id
  name    = "docs"
  type    = "A"

  alias {
    name                   = aws_lb.docs.dns_name
    zone_id                = aws_lb.docs.zone_id
    evaluate_target_health = true
  }
}
