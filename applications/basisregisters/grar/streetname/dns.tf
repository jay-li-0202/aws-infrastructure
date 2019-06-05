resource "aws_route53_record" "import-api" {
  zone_id = "${var.public_zone_id}"
  name    = "streetname-import.ops-api"
  type    = "CNAME"
  ttl     = "60"
  records = ["ops-api.${var.public_zone_name}"]
}
