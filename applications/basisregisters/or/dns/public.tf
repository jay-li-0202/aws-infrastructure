resource "aws_route53_zone" "public" {
  name          = var.public_zone_name
  comment       = "Public zone for Organisation Registry ${var.environment_label} ${var.environment_name}."
  force_destroy = true

  tags = {
    Name        = "Public Zone Organisation Registry // ${var.environment_label} ${var.environment_name}"
    Environment = var.tag_environment
    Productcode = var.tag_product
    Programma   = var.tag_program
    Contact     = var.tag_contact
  }
}

/*
wegwijs.vlaanderen.be	nameserver = ns3-01.azure-dns.org.
wegwijs.vlaanderen.be	nameserver = ns4-01.azure-dns.info.
wegwijs.vlaanderen.be	nameserver = ns2-01.azure-dns.net.
wegwijs.vlaanderen.be	nameserver = ns1-01.azure-dns.com.

@               A       104.40.183.236
api             CNAME   pwegwijsaivv2-api.azurewebsites.net
auth            CNAME   pwegwijsaiv-auth.azurewebsites.net
backoffice      CNAME   pwegwijsaiv-api.azurewebsites.net
*/

resource "aws_route53_record" "root_a" {
  zone_id = aws_route53_zone.public.zone_id
  name    = var.public_zone_name
  type    = "A"
  ttl     = "60"
  records = ["104.40.183.236"]
}

resource "aws_route53_record" "api_cname" {
  zone_id = aws_route53_zone.public.zone_id
  name    = "api.${var.public_zone_name}"
  type    = "CNAME"
  ttl     = "60"
  records = ["pwegwijsaivv2-api.azurewebsites.net"]
}

resource "aws_route53_record" "auth_cname" {
  zone_id = aws_route53_zone.public.zone_id
  name    = "auth.${var.public_zone_name}"
  type    = "CNAME"
  ttl     = "60"
  records = ["pwegwijsaiv-auth.azurewebsites.net"]
}

resource "aws_route53_record" "backoffice_cname" {
  zone_id = aws_route53_zone.public.zone_id
  name    = "backoffice.${var.public_zone_name}"
  type    = "CNAME"
  ttl     = "60"
  records = ["pwegwijsaiv-api.azurewebsites.net"]
}
