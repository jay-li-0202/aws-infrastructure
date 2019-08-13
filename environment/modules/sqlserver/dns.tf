resource "aws_route53_record" "db_private" {
  zone_id = var.private_zone_id
  type    = "CNAME"
  name    = "db"
  ttl     = "300"
  records = [aws_db_instance.basisregisters.address]
}
