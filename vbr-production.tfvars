// AWS Account Information
aws_region     = "eu-west-1"
aws_profile    = "vbr-production"
aws_account_id = "921707234258"

// Azure Account Information
azure_subscription_id = "98799e4a-733c-4218-abac-7b1cb29d10ea" // VBR-productie
azure_tenant_id       = "834d6985-72c6-486a-b1d5-5758cf0a293c"

// Terraform State Bucket
state_bucket = "basisregisters-aws-state"

// Tag information
tag_environment = "Production"
tag_product     = "P009"
tag_program     = "AGB"
tag_contact     = "david.cumps@kb.vlaanderen.be"

// General Information
environment_label = "Basisregisters"
environment_name  = "Production"

// VPC Information
vpc_cidr_block = "172.21.0.0/16"

// Privileged IPs
//admin_cidr_blocks = []

// DNS Information
public_zone_name  = "basisregisters.vlaanderen"
private_zone_name = "basisregisters.local"
alias_zone_name   = "basisregisters.vlaanderen.be"

// Elasticsearch Information
elasticsearch_version              = "6.5"
elasticsearch_volume_size          = 30
elasticsearch_master_instance_type = "t2.small.elasticsearch"
elasticsearch_master_cluster_size  = 3
elasticsearch_data_instance_type   = "t2.medium.elasticsearch"
elasticsearch_data_cluster_size    = 4

// ElastiCache Information
cache_redis_version   = "5.0.4"
cache_parameter_group = "default.redis5.0.cluster.on"
cache_instance_type   = "cache.m5.large"
cache_cluster_size    = 3

// AWS SQL Server Information
sql_version       = "14.00.3049.1.v1"
sql_major_version = "14.00"
sql_family        = "sqlserver-se-14.0"
sql_instance_type = "db.r4.large"
sql_username      = "basisregisters"
// sql_password = "x"
sql_storage                 = 1200
sql_backup_retention_period = 5
sql_multi_az                = false
sql_performance_insights_retention_period = 731

// Azure WMS Database Information
wms_db_edition  = "Standard"
wms_db_max_size = "527958016000" // 250GB
wms_db_type     = "S2"

// Datadog Information
// datadog_external_id = "x" // https://app.datadoghq.com/account/settings#integrations/amazon_web_services
// datadog_api_key = "x"     // https://app.datadoghq.com/account/settings#api
