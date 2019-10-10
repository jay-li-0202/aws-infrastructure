resource "aws_s3_bucket" "extract-logs" {
  bucket        = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-extracts-logs"
  acl           = "log-delivery-write"
  force_destroy = true

  tags = {
    Name        = "Extracts Logs // ${var.environment_label} ${var.environment_name}"
    Environment = var.tag_environment
    Productcode = var.tag_product
    Programma   = var.tag_program
    Contact     = var.tag_contact
  }

  lifecycle_rule {
    id                                     = "cleanup"
    enabled                                = true
    abort_incomplete_multipart_upload_days = 1
    prefix                                 = ""

    expiration {
      days = var.extracts_expiration_days
    }
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket" "extract" {
  bucket        = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-extracts"
  acl           = "private"
  force_destroy = true

  tags = {
    Name        = "Extracts // ${var.environment_label} ${var.environment_name}"
    Environment = var.tag_environment
    Productcode = var.tag_product
    Programma   = var.tag_program
    Contact     = var.tag_contact
  }

  logging {
    target_bucket = "${aws_s3_bucket.extract-logs.id}"
    target_prefix = "log/"
  }

  lifecycle_rule {
    id                                     = "cleanup"
    enabled                                = true
    abort_incomplete_multipart_upload_days = 1
    prefix                                 = ""

    expiration {
      days = var.extracts_expiration_days
    }
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

// resource "aws_s3_bucket_policy" "extract" {
//   bucket = aws_s3_bucket.extract.id

//   policy = <<POLICY
// {
//   "Id": "Policy",
//   "Version": "2012-10-17",
//   "Statement": [
//     {
//       "Action": [
//         "s3:PutObject"
//       ],
//       "Effect": "Allow",
//       "Resource": [
//         "${aws_s3_bucket.extract.arn}",
//         "${aws_s3_bucket.extract.arn}/*"
//       ],
//       "Principal": {
//         "Service": [ "${data.aws_elb_service_account.main.arn}" ]
//       }
//     }
//   ]
// }
// POLICY

// }
