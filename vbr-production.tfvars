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
public_zone_name             = "basisregisters.vlaanderen"
private_zone_name            = "basisregisters.local"
alias_zone_name              = "basisregisters.vlaanderen.be"
organisation_alias_zone_name = "wegwijs.vlaanderen.be"

// Elasticsearch Information
elasticsearch_version              = "7.1"
elasticsearch_volume_size          = 30
elasticsearch_master_instance_type = "t2.small.elasticsearch"
elasticsearch_master_cluster_size  = 3
elasticsearch_data_instance_type   = "t2.medium.elasticsearch"
elasticsearch_data_cluster_size    = 4

// ElastiCache Information
cache_redis_version   = "5.0.5"
cache_parameter_group = "default.redis5.0.cluster.on"
cache_instance_type   = "cache.m5.large"
cache_cluster_size    = 3

// AWS SQL Server Information
sql_version       = "14.00.3223.3.v1"
sql_major_version = "14.00"
sql_family        = "sqlserver-se-14.0"
sql_instance_type = "db.r5.xlarge"
sql_username      = "basisregisters"
// sql_password = "x"
sql_storage                               = 2500
sql_backup_retention_period               = 5
sql_multi_az                              = false
sql_performance_insights_retention_period = 731

// Azure WMS Database Information
wms_user        = "wms"
wms_db_server   = "vbr-wms"
wms_db_name     = "vbr-wms"
wms_location    = "West Europe"
wms_db_edition  = "Standard"
wms_db_max_size = "268435456000" // 250GB
wms_db_type     = "S2"
wms_rg_name     = "vbr-wms"

// Datadog Information
// datadog_external_id = "x" // https://app.datadoghq.com/account/settings#integrations/amazon_web_services
// datadog_api_key = "x"     // https://app.datadoghq.com/account/settings#api

// Basisregisters Information
logs_expiration_days       = 30
cloudtrail_expiration_days = 30
extracts_expiration_days   = 30

api_anonymous_rate_limit_per_5min = 100

portal_fqdn = "d2ae27z35yww91.cloudfront.net"
auth_fqdn   = "d1hfinbx08ox6c.cloudfront.net"

// Registries
site_version       = "1.14.2"
site_cpu           = 256
site_memory        = 512
site_min_instances = 2
site_max_instances = 4

public_api_version       = "2.40.3"
public_api_cpu           = 256
public_api_memory        = 512
public_api_min_instances = 2
public_api_max_instances = 4

municipality_registry_version            = "2.15.8"
municipality_registry_api_cpu            = 256
municipality_registry_api_memory         = 512
municipality_registry_api_min_instances  = 2
municipality_registry_api_max_instances  = 4
municipality_registry_projections_cpu    = 256
municipality_registry_projections_memory = 512
municipality_registry_cache_cpu          = 256
municipality_registry_cache_memory       = 512
municipality_registry_cache_enabled      = true

postal_registry_version            = "1.14.7"
postal_registry_api_cpu            = 256
postal_registry_api_memory         = 512
postal_registry_api_min_instances  = 2
postal_registry_api_max_instances  = 4
postal_registry_projections_cpu    = 256
postal_registry_projections_memory = 512
postal_registry_cache_cpu          = 256
postal_registry_cache_memory       = 512
postal_registry_cache_enabled      = true

streetname_registry_version            = "1.19.5"
streetname_registry_api_cpu            = 512
streetname_registry_api_memory         = 1024
streetname_registry_api_min_instances  = 2
streetname_registry_api_max_instances  = 4
streetname_registry_projections_cpu    = 512
streetname_registry_projections_memory = 1024
streetname_registry_cache_cpu          = 256
streetname_registry_cache_memory       = 512
streetname_registry_cache_enabled      = true

address_registry_version            = "1.17.4"
address_registry_api_cpu            = 4096
address_registry_api_memory         = 16384
address_registry_api_min_instances  = 2
address_registry_api_max_instances  = 6
address_registry_projections_cpu    = 4096
address_registry_projections_memory = 16384
address_registry_cache_cpu          = 256
address_registry_cache_memory       = 512
address_registry_cache_enabled      = false

building_registry_version            = "1.14.1"
building_registry_api_cpu            = 4096
building_registry_api_memory         = 16384
building_registry_api_min_instances  = 2
building_registry_api_max_instances  = 4
building_registry_projections_cpu    = 4096
building_registry_projections_memory = 16384
building_registry_cache_cpu          = 256
building_registry_cache_memory       = 512
building_registry_cache_enabled      = false

parcel_registry_version            = "2.3.0"
parcel_registry_api_cpu            = 4096
parcel_registry_api_memory         = 16384
parcel_registry_api_min_instances  = 2
parcel_registry_api_max_instances  = 4
parcel_registry_projections_cpu    = 4096
parcel_registry_projections_memory = 16384
parcel_registry_cache_cpu          = 256
parcel_registry_cache_memory       = 512
parcel_registry_cache_enabled      = false

publicservice_registry_version            = "1.12.2"
publicservice_registry_ui_min_instances   = 2
publicservice_registry_ui_cpu             = 256
publicservice_registry_ui_memory          = 512
publicservice_registry_api_cpu            = 256
publicservice_registry_api_memory         = 512
publicservice_registry_api_min_instances  = 2
publicservice_registry_api_max_instances  = 4
publicservice_registry_projections_cpu    = 256
publicservice_registry_projections_memory = 1024
publicservice_registry_cache_cpu          = 256
publicservice_registry_cache_memory       = 512
publicservice_registry_cache_enabled      = true
publicservice_registry_orafin_cpu         = 256
publicservice_registry_orafin_memory      = 512
publicservice_registry_orafin_enabled     = true

organisation_registry_version            = "1.0.5"
organisation_registry_ui_min_instances   = 2
organisation_registry_ui_cpu             = 256
organisation_registry_ui_memory          = 512
organisation_registry_api_cpu            = 256
organisation_registry_api_memory         = 1024
organisation_registry_api_min_instances  = 1
organisation_registry_api_max_instances  = 1
