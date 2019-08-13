resource "aws_db_subnet_group" "basisregisters" {
  name        = "basisregisters-${lower(replace(var.environment_name, " ", "-"))}"
  description = "Basisregisters DB Subnet Group."
  subnet_ids  = var.subnet_ids

  tags = {
    Name        = "DB Subnet Group // ${var.environment_label} ${var.environment_name}"
    Environment = var.tag_environment
    Productcode = var.tag_product
    Programma   = var.tag_program
    Contact     = var.tag_contact
  }
}

resource "aws_db_parameter_group" "basisregisters" {
  name        = "basisregisters-${lower(replace(var.environment_name, " ", "-"))}"
  description = "Basisregisters DB Parameter Group."
  family      = var.sql_family

  tags = {
    Name        = "DB Parameter Group // ${var.environment_label} ${var.environment_name}"
    Environment = var.tag_environment
    Productcode = var.tag_product
    Programma   = var.tag_program
    Contact     = var.tag_contact
  }
}

resource "aws_db_option_group" "basisregisters" {
  name                     = "option-group-basisregisters-${lower(replace(var.environment_name, " ", "-"))}"
  option_group_description = "Basisregisters DB Option Group"
  engine_name              = "sqlserver-se"
  major_engine_version     = var.sql_major_version

  option {
    option_name = "SQLSERVER_BACKUP_RESTORE"

    option_settings {
      name  = "IAM_ROLE_ARN"
      value = var.rds_s3backup_role
    }
  }

  tags = {
    Name        = "DB Option Group // ${var.environment_label} ${var.environment_name}"
    Environment = var.tag_environment
    Productcode = var.tag_product
    Programma   = var.tag_program
    Contact     = var.tag_contact
  }
}

resource "aws_db_instance" "basisregisters" {
  identifier          = "basisregisters-${lower(replace(var.environment_name, " ", "-"))}"
  publicly_accessible = false

  multi_az             = var.sql_multi_az
  db_subnet_group_name = aws_db_subnet_group.basisregisters.id
  parameter_group_name = aws_db_parameter_group.basisregisters.id
  option_group_name    = aws_db_option_group.basisregisters.id
  timezone             = "UTC"
  license_model        = "license-included"

  engine            = "sqlserver-se"
  engine_version    = var.sql_version
  instance_class    = var.sql_instance_type
  storage_type      = "gp2"
  allocated_storage = var.sql_storage

  vpc_security_group_ids = [aws_security_group.basisregisters-db.id]

  username = var.sql_username
  password = var.sql_password

  monitoring_interval                   = 30
  monitoring_role_arn                   = var.monitoring_role
  performance_insights_enabled          = true
  performance_insights_retention_period = var.sql_performance_insights_retention_period

  allow_major_version_upgrade = true
  auto_minor_version_upgrade  = true

  backup_retention_period = var.sql_backup_retention_period
  backup_window           = var.sql_backup_window

  maintenance_window = var.sql_maintenance_window

  storage_encrypted = true

  apply_immediately = true

  skip_final_snapshot       = false
  final_snapshot_identifier = "basisregisters-${lower(replace(var.environment_name, " ", "-"))}-final"

  tags = {
    Name        = "SQL Server // ${var.environment_label} ${var.environment_name}"
    Environment = var.tag_environment
    Productcode = var.tag_product
    Programma   = var.tag_program
    Contact     = var.tag_contact
  }
}
