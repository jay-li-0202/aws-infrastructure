// AWS Account Information
aws_region     = "eu-west-1"
aws_profile    = "vbr-staging"
aws_account_id = "830031229216"

// Azure Account Information
azure_subscription_id = "4fcc49a0-0e99-4090-8b0c-286779f92a7d" // VBR-beta
azure_tenant_id       = "834d6985-72c6-486a-b1d5-5758cf0a293c"

// Terraform State Bucket
state_bucket = "basisregisters-staging-aws-state"

// Tag information
tag_environment = "Test"
tag_product     = "P009"
tag_program     = "AGB"
tag_contact     = "david.cumps@kb.vlaanderen.be"

// General Information
environment_label = "Basisregisters"
environment_name  = "Staging"

// VPC Information
vpc_cidr_block = "172.21.0.0/16"

// Privileged IPs
//admin_cidr_blocks = []

// DNS Information
public_zone_name  = "staging-basisregisters.vlaanderen"
private_zone_name = "staging-basisregisters.local"
alias_zone_name              = "basisregisters.dev-vlaanderen.be"
organisation_alias_zone_name = "wegwijs.dev-vlaanderen.be"

// Elasticsearch Information
elasticsearch_version              = "6.5"
elasticsearch_volume_size          = 30
elasticsearch_master_instance_type = "t2.small.elasticsearch"
elasticsearch_master_cluster_size  = 3
elasticsearch_data_instance_type   = "t2.small.elasticsearch"
elasticsearch_data_cluster_size    = 2

// ElastiCache Information
cache_redis_version   = "5.0.5"
cache_parameter_group = "default.redis5.0.cluster.on"
cache_instance_type   = "cache.t2.medium"
cache_cluster_size    = 3

// SQL Server Information
sql_version       = "14.00.3223.3.v1"
sql_major_version = "14.00"
sql_family        = "sqlserver-se-14.0"
sql_instance_type = "db.r4.large"
sql_username      = "basisregisters"
// sql_password = "x"
sql_storage                 = 500
sql_backup_retention_period = 2
sql_multi_az                = false
sql_performance_insights_retention_period = 7

// Azure WMS Database Information
wms_user        = "wms"
wms_db_server   = "vbr-wms-staging"
wms_db_name     = "vbr-wms"
wms_location    = "West Europe"
wms_db_edition  = "Standard"
wms_db_max_size = "268435456000" // 250GB
wms_db_type     = "S1"
wms_rg_name     = "vbr-wms-staging"

// Datadog Information
// datadog_external_id = "x" // https://app.datadoghq.com/account/settings#integrations/amazon_web_services
// datadog_api_key = "x"     // https://app.datadoghq.com/account/settings#api

// Basisregisters Information
logs_expiration_days       = 30
cloudtrail_expiration_days = 30
extracts_expiration_days   = 30

api_anonymous_rate_limit_per_5min = 100

portal_fqdn = "d2gtj4t3cfp7t.cloudfront.net"
auth_fqdn = "d3g80n6oqcib3n.cloudfront.net"
