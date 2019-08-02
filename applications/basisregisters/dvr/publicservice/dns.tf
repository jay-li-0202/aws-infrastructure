resource "aws_route53_record" "projections-api" {
  zone_id = var.public_zone_id
  name    = "publicservice-projections.ops-api"
  type    = "CNAME"
  ttl     = "60"
  records = ["ops-api.${var.public_zone_name}"]
}
