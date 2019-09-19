resource "aws_route53_record" "import-api" {
  zone_id = var.public_zone_id
  name    = "municipality-import.ops-api"
  type    = "CNAME"
  ttl     = "60"
  records = ["ops-api.${var.public_zone_name}"]
}

resource "aws_route53_record" "projections-api" {
  zone_id = var.public_zone_id
  name    = "municipality-projections.ops-api"
  type    = "CNAME"
  ttl     = "60"
  records = ["ops-api.${var.public_zone_name}"]
}

resource "aws_route53_record" "extract-api" {
  zone_id = var.public_zone_id
  name    = "municipality-extract.ops-api"
  type    = "CNAME"
  ttl     = "60"
  records = ["ops-api.${var.public_zone_name}"]
}

resource "aws_route53_record" "legacy-api" {
  zone_id = var.public_zone_id
  name    = "municipality-legacy.ops-api"
  type    = "CNAME"
  ttl     = "60"
  records = ["ops-api.${var.public_zone_name}"]
}
