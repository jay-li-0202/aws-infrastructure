// AWS Account Information
aws_region     = "eu-west-1"
aws_profile    = "vbr-staging"
aws_account_id = "830031229216"

// Terraform State Bucket
state_bucket = "basisregisters-staging-aws-state"

// Tag information
tag_environment = "Test"
tag_product     = "P009"
tag_program     = "AGB"
tag_contact     = "david.cumps@kb.vlaanderen.be"

// General Information
environment_label = "Basisregisters"
environment_name = "Staging"

// VPC Information
vpc_cidr_block = "172.21.0.0/16"

// DNS Information
public_zone_name = "staging-basisregisters.vlaanderen"
private_zone_name = "staging-basisregisters.local"

// Elasticsearch Information
elasticsearch_version = "6.5"
elasticsearch_volume_size = 30
elasticsearch_master_instance_type = "t2.small.elasticsearch"
elasticsearch_master_cluster_size = 3
elasticsearch_data_instance_type = "t2.small.elasticsearch"
elasticsearch_data_cluster_size = 2

// ElastiCache Information
cache_redis_version = "5.0.3"
cache_parameter_group = "default.redis5.0.cluster.on"
cache_instance_type = "cache.t2.medium"
cache_cluster_size = 3

// SQL Server Information
sql_version = "14.00.3049.1.v1"
sql_major_version = "14.00"
sql_family = "sqlserver-se-14.0"
sql_instance_type = "db.r4.large"
// sql_username = "x"
// sql_password = "x"
sql_storage = 500
sql_backup_retention_period = 2

// Datadog Information
// datadog_external_id = "x" // https://app.datadoghq.com/account/settings#integrations/amazon_web_services
// datadog_api_key = "x"     // https://app.datadoghq.com/account/settings#api
