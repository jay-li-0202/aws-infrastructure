resource "aws_iam_role" "rds-backup" {
  name               = "${lower(replace(var.environment_label, " ", "-"))}-${lower(replace(var.environment_name, " ", "-"))}-rds-backups"
  description        = "Allows RDS to backup to S3."
  assume_role_policy = data.aws_iam_policy_document.rds_backup_assume_role.json

  tags = {
    Name        = "RDS Backups // ${var.environment_label} ${var.environment_name}"
    Environment = var.tag_environment
    Productcode = var.tag_product
    Programma   = var.tag_program
    Contact     = var.tag_contact
  }
}

data "aws_iam_policy_document" "rds_backup_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["rds.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "rds-backup" {
  statement {
    effect    = "Allow"
    resources = [aws_s3_bucket.rds-backup.arn]

    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation",
    ]
  }

  statement {
    effect    = "Allow"
    resources = ["${aws_s3_bucket.rds-backup.arn}/*"]

    actions = [
      "s3:GetObjectMetaData",
      "s3:GetObject",
      "s3:PutObject",
      "s3:ListMultipartUploadParts",
      "s3:AbortMultipartUpload",
    ]
  }
}

resource "aws_iam_role_policy" "rds_backup_role_policy" {
  name   = "${lower(replace(var.environment_label, " ", "-"))}-${lower(replace(var.environment_name, " ", "-"))}-rds-backup"
  role   = aws_iam_role.rds-backup.id
  policy = data.aws_iam_policy_document.rds-backup.json
}

