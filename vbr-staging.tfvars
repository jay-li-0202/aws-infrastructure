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
elasticsearch_version = "6.4"
elasticsearch_volume_size = 30
elasticsearch_master_instance_type = "t2.small.elasticsearch"
elasticsearch_master_cluster_size = 3
elasticsearch_data_instance_type = "t2.small.elasticsearch"
elasticsearch_data_cluster_size = 2
