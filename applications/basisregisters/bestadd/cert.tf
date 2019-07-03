resource "aws_acm_certificate" "cert" {
  provider = "aws.cert"

  validation_method = "DNS"
  domain_name       = "${var.api_url}.${var.cert_public_zone_name}"

  lifecycle {
    create_before_destroy = true
  }

  tags {
    Name        = "Basisregisters Api Certificate // ${var.environment_label} ${var.environment_name}"
    Environment = "${var.tag_environment}"
    Productcode = "${var.tag_product}"
    Programma   = "${var.tag_program}"
    Contact     = "${var.tag_contact}"
  }
}

resource "aws_route53_record" "public_cert_validation0" {
  zone_id = "${var.cert_public_zone_id}"

  name    = "${aws_acm_certificate.cert.domain_validation_options.0.resource_record_name}"
  type    = "${aws_acm_certificate.cert.domain_validation_options.0.resource_record_type}"
  records = ["${aws_acm_certificate.cert.domain_validation_options.0.resource_record_value}"]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "cert" {
  provider = "aws.cert"

  certificate_arn = "${aws_acm_certificate.cert.arn}"

  validation_record_fqdns = [
    "${aws_route53_record.public_cert_validation0.fqdn}",
  ]
}
