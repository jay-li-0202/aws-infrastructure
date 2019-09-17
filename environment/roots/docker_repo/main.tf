variable "aws_region" {
}

variable "aws_profile" {
}

variable "aws_account_id" {
}

variable "environment_label" {
}

variable "environment_name" {
}

variable "tag_environment" {
}

variable "tag_product" {
}

variable "tag_program" {
}

variable "tag_contact" {
}

provider "aws" {
  version             = "~> 2.28.1"
  region              = var.aws_region
  profile             = var.aws_profile
  allowed_account_ids = [var.aws_account_id]
}

terraform {
  backend "s3" {
    key = "docker/terraform.tfstate"
  }
}

module "municipality-registry" {
  source = "../../modules/docker_repo"

  environment_label = var.environment_label
  environment_name  = var.environment_name

  tag_environment = var.tag_environment
  tag_product     = var.tag_product
  tag_program     = var.tag_program
  tag_contact     = var.tag_contact

  // NOTE: Append to the bottom if you do not want to nuke the ones below the line you add!
  repository_names = [
    "municipality-registry/api-legacy",
    "municipality-registry/api-crab-import",
    "municipality-registry/api-extract",
    "municipality-registry/projector",
  ]
}

module "postal-registry" {
  source = "../../modules/docker_repo"

  environment_label = var.environment_label
  environment_name  = var.environment_name

  tag_environment = var.tag_environment
  tag_product     = var.tag_product
  tag_program     = var.tag_program
  tag_contact     = var.tag_contact

  // NOTE: Append to the bottom if you do not want to nuke the ones below the line you add!
  repository_names = [
    "postal-registry/api-legacy",
    "postal-registry/api-crab-import",
    "postal-registry/api-extract",
    "postal-registry/projector",
    "postal-registry/projections-syndication",
  ]
}

module "streetname-registry" {
  source = "../../modules/docker_repo"

  environment_label = var.environment_label
  environment_name  = var.environment_name

  tag_environment = var.tag_environment
  tag_product     = var.tag_product
  tag_program     = var.tag_program
  tag_contact     = var.tag_contact

  // NOTE: Append to the bottom if you do not want to nuke the ones below the line you add!
  repository_names = [
    "streetname-registry/api-legacy",
    "streetname-registry/api-crab-import",
    "streetname-registry/api-extract",
    "streetname-registry/projector",
    "streetname-registry/projections-syndication",
  ]
}

module "address-registry" {
  source = "../../modules/docker_repo"

  environment_label = var.environment_label
  environment_name  = var.environment_name

  tag_environment = var.tag_environment
  tag_product     = var.tag_product
  tag_program     = var.tag_program
  tag_contact     = var.tag_contact

  // NOTE: Append to the bottom if you do not want to nuke the ones below the line you add!
  repository_names = [
    "address-registry/api-legacy",
    "address-registry/api-crab-import",
    "address-registry/api-extract",
    "address-registry/projector",
    "address-registry/projections-syndication",
  ]
}

module "building-registry" {
  source = "../../modules/docker_repo"

  environment_label = var.environment_label
  environment_name  = var.environment_name

  tag_environment = var.tag_environment
  tag_product     = var.tag_product
  tag_program     = var.tag_program
  tag_contact     = var.tag_contact

  // NOTE: Append to the bottom if you do not want to nuke the ones below the line you add!
  repository_names = [
    "building-registry/api-legacy",
    "building-registry/api-crab-import",
    "building-registry/api-extract",
    "building-registry/projector",
    "building-registry/projections-syndication",
  ]
}

module "parcel-registry" {
  source = "../../modules/docker_repo"

  environment_label = var.environment_label
  environment_name  = var.environment_name

  tag_environment = var.tag_environment
  tag_product     = var.tag_product
  tag_program     = var.tag_program
  tag_contact     = var.tag_contact

  // NOTE: Append to the bottom if you do not want to nuke the ones below the line you add!
  repository_names = [
    "parcel-registry/api-legacy",
    "parcel-registry/api-crab-import",
    "parcel-registry/api-extract",
    "parcel-registry/projector",
    "parcel-registry/projections-syndication",
  ]
}

module "public-service-registry" {
  source = "../../modules/docker_repo"

  environment_label = var.environment_label
  environment_name  = var.environment_name

  tag_environment = var.tag_environment
  tag_product     = var.tag_product
  tag_program     = var.tag_program
  tag_contact     = var.tag_contact

  // NOTE: Append to the bottom if you do not want to nuke the ones below the line you add!
  repository_names = [
    "public-service-registry/ui",
    "public-service-registry/api",
    "public-service-registry/batch-orafin",
    "public-service-registry/projector",
  ]
}

module "road-registry" {
  source = "../../modules/docker_repo"

  environment_label = var.environment_label
  environment_name  = var.environment_name

  tag_environment = var.tag_environment
  tag_product     = var.tag_product
  tag_program     = var.tag_program
  tag_contact     = var.tag_contact

  // NOTE: Append to the bottom if you do not want to nuke the ones below the line you add!
  repository_names = [
    "road-registry/ui",
    "road-registry/api",
    "road-registry/legacy-stream-loader",
    "road-registry/projector",
  ]
}

module "organisation-registry" {
  source = "../../modules/docker_repo"

  environment_label = var.environment_label
  environment_name  = var.environment_name

  tag_environment = var.tag_environment
  tag_product     = var.tag_product
  tag_program     = var.tag_program
  tag_contact     = var.tag_contact

  // NOTE: Append to the bottom if you do not want to nuke the ones below the line you add!
  repository_names = [
    "organisation-registry/api-wegwijs",
    "organisation-registry/batch-vlaanderenbe",
    "organisation-registry/elasticsearch-projections",
    "organisation-registry/elasticsearch-janitor",
    "organisation-registry/projections-delegations",
    "organisation-registry/projections-reporting",
    "organisation-registry/batch-agentschapzorgengezondheidftpdump",
    "organisation-registry/openid",
    "organisation-registry/ui",
  ]
}

module "bank-account-number-registry" {
  source = "../../modules/docker_repo"

  environment_label = var.environment_label
  environment_name  = var.environment_name

  tag_environment = var.tag_environment
  tag_product     = var.tag_product
  tag_program     = var.tag_program
  tag_contact     = var.tag_contact

  // NOTE: Append to the bottom if you do not want to nuke the ones below the line you add!
  repository_names = [
    "bank-account-number-registry/api",
    "bank-account-number-registry/projector",
  ]
}

module "public-api" {
  source = "../../modules/docker_repo"

  environment_label = var.environment_label
  environment_name  = var.environment_name

  tag_environment = var.tag_environment
  tag_product     = var.tag_product
  tag_program     = var.tag_program
  tag_contact     = var.tag_contact

  // NOTE: Append to the bottom if you do not want to nuke the ones below the line you add!
  repository_names = [
    "public-api/api",
    "public-api/api-legacy",
  ]
}

module "redis" {
  source = "../../modules/docker_repo"

  environment_label = var.environment_label
  environment_name  = var.environment_name

  tag_environment = var.tag_environment
  tag_product     = var.tag_product
  tag_program     = var.tag_program
  tag_contact     = var.tag_contact

  // NOTE: Append to the bottom if you do not want to nuke the ones below the line you add!
  repository_names = [
    "redis/redis-populator",
  ]
}

module "general" {
  source = "../../modules/docker_repo"

  environment_label = var.environment_label
  environment_name  = var.environment_name

  tag_environment = var.tag_environment
  tag_product     = var.tag_product
  tag_program     = var.tag_program
  tag_contact     = var.tag_contact

  // NOTE: Append to the bottom if you do not want to nuke the ones below the line you add!
  repository_names = [
    "basisregisters/build-agent",
  ]
}

module "docker" {
  source = "../../modules/docker_user"
}

output "ecr_uri" {
  value = "${var.aws_account_id}.dkr.ecr.${var.aws_region}.amazonaws.com"
}

output "docker_user_name" {
  value = module.docker.docker_user_name
}

output "docker_user_key" {
  value = module.docker.docker_user_key
}

output "docker_user_secret" {
  value = module.docker.docker_user_secret
}
