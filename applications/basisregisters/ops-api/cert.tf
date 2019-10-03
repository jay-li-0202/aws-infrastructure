resource "aws_acm_certificate" "main" {
  validation_method = "DNS"
  domain_name       = "ops-api.${var.cert_public_zone_name}"

  subject_alternative_names = [
    "*.ops-api.${var.cert_public_zone_name}",
    "*.ops-api.${var.cert_alias_zone_name}",
    "dev-api.${var.cert_public_zone_name}",
    "ops-api.${var.cert_alias_zone_name}",
    "dev-api.${var.cert_alias_zone_name}",
  ]

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name        = "Ops Api Certificate // ${var.environment_label} ${var.environment_name}"
    Environment = var.tag_environment
    Productcode = var.tag_product
    Programma   = var.tag_program
    Contact     = var.tag_contact
  }
}

resource "aws_route53_record" "public_cert_validation0" {
  zone_id = var.cert_public_zone_id

  name    = aws_acm_certificate.main.domain_validation_options[0].resource_record_name
  type    = aws_acm_certificate.main.domain_validation_options[0].resource_record_type
  records = [aws_acm_certificate.main.domain_validation_options[0].resource_record_value]
  ttl     = 60
}

// resource "aws_route53_record" "public_cert_validation1" {
//   zone_id = var.cert_alias_zone_id

//   name    = aws_acm_certificate.main.domain_validation_options[1].resource_record_name
//   type    = aws_acm_certificate.main.domain_validation_options[1].resource_record_type
//   records = [aws_acm_certificate.main.domain_validation_options[1].resource_record_value]
//   ttl     = 60
// }

// resource "aws_route53_record" "public_cert_validation2" {
//   zone_id = var.cert_public_zone_id

//   name    = aws_acm_certificate.main.domain_validation_options[2].resource_record_name
//   type    = aws_acm_certificate.main.domain_validation_options[2].resource_record_type
//   records = [aws_acm_certificate.main.domain_validation_options[2].resource_record_value]
//   ttl     = 60
// }

resource "aws_route53_record" "public_cert_validation3" {
  zone_id = var.cert_public_zone_id

  name    = aws_acm_certificate.main.domain_validation_options[3].resource_record_name
  type    = aws_acm_certificate.main.domain_validation_options[3].resource_record_type
  records = [aws_acm_certificate.main.domain_validation_options[3].resource_record_value]
  ttl     = 60
}

resource "aws_route53_record" "public_cert_validation4" {
  zone_id = var.cert_alias_zone_id

  name    = aws_acm_certificate.main.domain_validation_options[4].resource_record_name
  type    = aws_acm_certificate.main.domain_validation_options[4].resource_record_type
  records = [aws_acm_certificate.main.domain_validation_options[4].resource_record_value]
  ttl     = 60
}

resource "aws_route53_record" "public_cert_validation5" {
  zone_id = var.cert_alias_zone_id

  name    = aws_acm_certificate.main.domain_validation_options[5].resource_record_name
  type    = aws_acm_certificate.main.domain_validation_options[5].resource_record_type
  records = [aws_acm_certificate.main.domain_validation_options[5].resource_record_value]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "main" {
  certificate_arn = aws_acm_certificate.main.arn

  validation_record_fqdns = [
    aws_route53_record.public_cert_validation0.fqdn,
    // aws_route53_record.public_cert_validation1.fqdn,
    // aws_route53_record.public_cert_validation2.fqdn,
    aws_route53_record.public_cert_validation3.fqdn,
    aws_route53_record.public_cert_validation4.fqdn,
    aws_route53_record.public_cert_validation5.fqdn,
  ]
}
