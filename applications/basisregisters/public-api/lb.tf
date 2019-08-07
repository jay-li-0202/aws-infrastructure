resource "aws_lb" "api" {
  name               = "${var.app}-public-api"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.api-lb.id]
  subnets            = var.public_subnets

  enable_deletion_protection = false
  ip_address_type            = "ipv4"
  enable_http2               = true

  access_logs {
    enabled = true
    bucket  = aws_s3_bucket.lb_access_logs.bucket
  }

  tags = {
    Name        = "Public Api // ${var.environment_label} ${var.environment_name}"
    Environment = var.tag_environment
    Productcode = var.tag_product
    Programma   = var.tag_program
    Contact     = var.tag_contact
  }
}

resource "aws_lb_target_group" "api" {
  name                 = "${var.app}-public-api"
  port                 = var.lb_port
  protocol             = var.lb_protocol
  vpc_id               = var.vpc_id
  target_type          = "ip"
  deregistration_delay = var.deregistration_delay

  health_check {
    path = "/health"
  }

  tags = {
    Name        = "Public Api // ${var.environment_label} ${var.environment_name}"
    Environment = var.tag_environment
    Productcode = var.tag_product
    Programma   = var.tag_program
    Contact     = var.tag_contact
  }
}

data "aws_elb_service_account" "api" {
}

resource "aws_s3_bucket" "lb_access_logs" {
  bucket        = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-public-api-lb-access-logs"
  acl           = "private"
  force_destroy = true

  tags = {
    Name        = "Public Api Loadbalancer Logs // ${var.environment_label} ${var.environment_name}"
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
      days = var.lb_access_logs_expiration_days
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

resource "aws_s3_bucket_policy" "lb_access_logs" {
  bucket = aws_s3_bucket.lb_access_logs.id

  policy = <<POLICY
{
  "Id": "Policy",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.lb_access_logs.arn}",
        "${aws_s3_bucket.lb_access_logs.arn}/*"
      ],
      "Principal": {
        "AWS": [ "${data.aws_elb_service_account.api.arn}" ]
      }
    }
  ]
}
POLICY

}

resource "aws_lambda_permission" "lb_access_logs" {
  statement_id  = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-public-api-lb-access-logs"
  action        = "lambda:InvokeFunction"
  function_name = var.datadog_logging_lambda
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.lb_access_logs.arn
}

resource "aws_s3_bucket_notification" "lb_access_logs" {
  bucket = aws_s3_bucket.lb_access_logs.id

  lambda_function {
    lambda_function_arn = var.datadog_logging_lambda
    events              = ["s3:ObjectCreated:*", "s3:ObjectRemoved:*"]
  }
}

