resource "aws_s3_bucket" "log" {
  bucket        = "${lower(replace(var.environment_label, " ", "-"))}-${lower(replace(var.environment_name, " ", "-"))}-logs"
  acl           = "private"
  force_destroy = true

  lifecycle_rule {
    id                                     = "cleanup"
    enabled                                = true
    abort_incomplete_multipart_upload_days = 1
    prefix                                 = ""

    expiration {
      days = var.logs_expiration_days
    }
  }

  tags = {
    Name        = "Logs // ${var.environment_label} ${var.environment_name}"
    Environment = var.tag_environment
    Productcode = var.tag_product
    Programma   = var.tag_program
    Contact     = var.tag_contact
  }
}

resource "aws_s3_bucket" "backup" {
  bucket        = "${lower(replace(var.environment_label, " ", "-"))}-${lower(replace(var.environment_name, " ", "-"))}-backups"
  acl           = "private"
  force_destroy = true

  tags = {
    Name        = "Backups // ${var.environment_label} ${var.environment_name}"
    Environment = var.tag_environment
    Productcode = var.tag_product
    Programma   = var.tag_program
    Contact     = var.tag_contact
  }
}

resource "aws_s3_bucket" "rds-backup" {
  bucket        = "${lower(replace(var.environment_label, " ", "-"))}-${lower(replace(var.environment_name, " ", "-"))}-rds-backups"
  acl           = "private"
  force_destroy = true

  tags = {
    Name        = "RDS Backups // ${var.environment_label} ${var.environment_name}"
    Environment = var.tag_environment
    Productcode = var.tag_product
    Programma   = var.tag_program
    Contact     = var.tag_contact
  }
}

resource "aws_s3_bucket" "portal" {
  bucket        = "${lower(replace(var.environment_label, " ", "-"))}-${lower(replace(var.environment_name, " ", "-"))}-portal"
  acl           = "private"
  force_destroy = true

  tags = {
    Name        = "Portal // ${var.environment_label} ${var.environment_name}"
    Environment = var.tag_environment
    Productcode = var.tag_product
    Programma   = var.tag_program
    Contact     = var.tag_contact
  }
}
