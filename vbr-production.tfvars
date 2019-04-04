// AWS Account Information
aws_region     = "eu-west-1"
aws_profile    = "vbr-production"
aws_account_id = "921707234258"

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

// DNS Information
public_zone_name  = "basisregisters.vlaanderen"
private_zone_name = "basisregisters.local"

// Elasticsearch Information
elasticsearch_version = "6.4"
elasticsearch_volume_size = 30
elasticsearch_master_instance_type = "t2.small.elasticsearch"
elasticsearch_master_cluster_size = 3
elasticsearch_data_instance_type = "t2.medium.elasticsearch"
elasticsearch_data_cluster_size = 4
