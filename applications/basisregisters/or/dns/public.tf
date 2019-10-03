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
@               TXT     vbr-prod-queryservice.azurewebsites.net
awverify        CNAME   awverify.vbr-prod-queryservice.azurewebsites.net
beta            CNAME   vbr-beta-mgmtsvc.azurewebsites.net
awverify.beta   CNAME   awverify.vbr-beta-mgmtsvc.azurewebsites.net
*/

// resource "aws_route53_record" "root_a" {
//   zone_id = aws_route53_zone.public.zone_id
//   name    = var.public_zone_name
//   type    = "A"
//   ttl     = "60"
//   records = ["52.174.235.29"]
// }

// resource "aws_route53_record" "root_txt" {
//   zone_id = aws_route53_zone.public.zone_id
//   name    = var.public_zone_name
//   type    = "TXT"
//   ttl     = "60"
//   records = ["vbr-prod-queryservice.azurewebsites.net"]
// }

// resource "aws_route53_record" "awverify_cname" {
//   zone_id = aws_route53_zone.public.zone_id
//   name    = "awverify.${var.public_zone_name}"
//   type    = "CNAME"
//   ttl     = "60"
//   records = ["awverify.vbr-prod-queryservice.azurewebsites.net"]
// }

// resource "aws_route53_record" "beta_cname" {
//   zone_id = aws_route53_zone.public.zone_id
//   name    = "beta.${var.public_zone_name}"
//   type    = "CNAME"
//   ttl     = "60"
//   records = ["vbr-beta-mgmtsvc.azurewebsites.net"]
// }

// resource "aws_route53_record" "awverify_beta_cname" {
//   zone_id = aws_route53_zone.public.zone_id
//   name    = "awverify.beta.${var.public_zone_name}"
//   type    = "CNAME"
//   ttl     = "60"
//   records = ["awverify.vbr-beta-mgmtsvc.azurewebsites.net"]
// }

// // The ones below are already part of the new architecture
// resource "aws_route53_record" "wms_cname" {
//   zone_id = aws_route53_zone.public.zone_id
//   name    = "wms.${var.public_zone_name}"
//   type    = "CNAME"
//   ttl     = "60"
//   records = ["${var.wms_db_fqdn}"]
// }
