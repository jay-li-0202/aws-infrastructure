resource "aws_route53_record" "es_private" {
  zone_id = "${var.private_zone_id}"
  type    = "CNAME"
  name    = "es"
  ttl     = "300"
  records = ["${aws_elasticsearch_domain.es.endpoint}"]
}
