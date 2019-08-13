resource "aws_route53_record" "elasticache_private" {
  zone_id = var.private_zone_id
  type    = "CNAME"
  name    = "cache"
  ttl     = "300"
  records = [aws_elasticache_replication_group.elasticache.configuration_endpoint_address]
}
