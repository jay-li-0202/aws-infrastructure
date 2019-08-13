resource "aws_route53_record" "public-api" {
  zone_id = var.public_zone_id
  name    = "public-api"
  type    = "A"

  alias {
    name                   = var.api_lb_dns_name
    zone_id                = var.api_lb_zone_id
    evaluate_target_health = true
  }
}
