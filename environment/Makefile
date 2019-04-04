default: help

ACTION ?= plan

##############

roots/state_bootstrap/.terraform/terraform.tfstate:
	@cd roots/state_bootstrap && \
		terraform init

.PHONY: state-bootstrap
state-bootstrap: roots/state_bootstrap/.terraform/terraform.tfstate ## Run Terraform to bootstrap an S3 remote state bucket
	$(call check_undefined, AWS_PROFILE, AWS Profile should not be defined)
	$(call check_defined, ACTION, terraform action to perform)
	$(call check_defined, ENVIRONMENT, Environment to use, 'staging' or 'production')
	@cd roots/state_bootstrap && \
		terraform $(ACTION) \
			-var-file=../../../$(ENVIRONMENT).tfvars \
			-state=state_bootstrap.tfstate \
			-lock=false && \
		rm -f state_bootstrap.tfstate

##############

roots/account_bootstrap/.terraform/terraform.tfstate:
	@cd roots/account_bootstrap && \
		terraform init \
			-backend-config=../../../$(ENVIRONMENT)-backend.tfvars

.PHONY: account-bootstrap
account-bootstrap: roots/account_bootstrap/.terraform/terraform.tfstate ## Run Terraform to bootstrap an empty AWS account
	$(call check_undefined, AWS_PROFILE, AWS Profile should not be defined)
	$(call check_defined, ACTION, terraform action to perform)
	$(call check_defined, ENVIRONMENT, Environment to use, 'staging' or 'production')
	@cd roots/account_bootstrap && \
		terraform $(ACTION) \
			-var-file=../../../$(ENVIRONMENT).tfvars

##############

roots/base_vpc/.terraform/terraform.tfstate:
	@cd roots/base_vpc && \
		terraform init \
			-backend-config=../../../$(ENVIRONMENT)-backend.tfvars

.PHONY: base-vpc
base-vpc: roots/base_vpc/.terraform/terraform.tfstate ## Run Terraform to create a base VPC
	$(call check_undefined, AWS_PROFILE, AWS Profile should not be defined)
	$(call check_defined, ACTION, terraform action to perform)
	$(call check_defined, ENVIRONMENT, Environment to use, 'staging' or 'production')
	@cd roots/base_vpc && \
		terraform $(ACTION) \
			-var-file=../../../$(ENVIRONMENT).tfvars

##############

roots/dns/.terraform/terraform.tfstate:
	@cd roots/dns && \
		terraform init \
			-backend-config=../../../$(ENVIRONMENT)-backend.tfvars

.PHONY: dns
dns: roots/dns/.terraform/terraform.tfstate ## Run Terraform to create DNS zones
	$(call check_undefined, AWS_PROFILE, AWS Profile should not be defined)
	$(call check_defined, ACTION, terraform action to perform)
	$(call check_defined, ENVIRONMENT, Environment to use, 'staging' or 'production')
	@cd roots/dns && \
		terraform $(ACTION) \
			-var-file=../../../$(ENVIRONMENT).tfvars

##############

roots/docker_repo/.terraform/terraform.tfstate:
	@cd roots/docker_repo && \
		terraform init \
			-backend-config=../../../$(ENVIRONMENT)-backend.tfvars

.PHONY: docker-repo
docker-repo: roots/docker_repo/.terraform/terraform.tfstate ## Run Terraform to create Docker repositories
	$(call check_undefined, AWS_PROFILE, AWS Profile should not be defined)
	$(call check_defined, ACTION, terraform action to perform)
	$(call check_defined, ENVIRONMENT, Environment to use, 'staging' or 'production')
	@cd roots/docker_repo && \
		terraform $(ACTION) \
			-var-file=../../../$(ENVIRONMENT).tfvars

##############

roots/elasticsearch/.terraform/terraform.tfstate:
	@cd roots/elasticsearch && \
		terraform init \
			-backend-config=../../../$(ENVIRONMENT)-backend.tfvars

.PHONY: elasticsearch
elasticsearch: roots/elasticsearch/.terraform/terraform.tfstate ## Run Terraform to create an Elasticsearch cluster
	$(call check_undefined, AWS_PROFILE, AWS Profile should not be defined)
	$(call check_defined, ACTION, terraform action to perform)
	$(call check_defined, ENVIRONMENT, Environment to use, 'staging' or 'production')
	@cd roots/elasticsearch && \
		terraform $(ACTION) \
			-var-file=../../../$(ENVIRONMENT).tfvars

##############

roots/cache/.terraform/terraform.tfstate:
	@cd roots/cache && \
		terraform init \
			-backend-config=../../../$(ENVIRONMENT)-backend.tfvars

.PHONY: cache
cache: roots/cache/.terraform/terraform.tfstate ## Run Terraform to create an Elasticache Redis cluster
	$(call check_undefined, AWS_PROFILE, AWS Profile should not be defined)
	$(call check_defined, ACTION, terraform action to perform)
	$(call check_defined, ENVIRONMENT, Environment to use, 'staging' or 'production')
	@cd roots/cache && \
		terraform $(ACTION) \
			-var-file=../../../$(ENVIRONMENT).tfvars

##############

roots/sqlserver/.terraform/terraform.tfstate:
	@cd roots/sqlserver && \
		terraform init \
			-backend-config=../../../$(ENVIRONMENT)-backend.tfvars

.PHONY: sqlserver
sqlserver: roots/sqlserver/.terraform/terraform.tfstate ## Run Terraform to create a SQL Server database
	$(call check_undefined, AWS_PROFILE, AWS Profile should not be defined)
	$(call check_defined, ACTION, terraform action to perform)
	$(call check_defined, ENVIRONMENT, Environment to use, 'staging' or 'production')
	@cd roots/sqlserver && \
		terraform $(ACTION) \
			-var-file=../../../$(ENVIRONMENT).tfvars

##############

.PHONY: help
help: ## Display this information. Default target.
	@echo "Valid targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

##############

check_defined = \
		$(strip $(foreach 1,$1, \
		$(call __check_defined,$1,$(strip $(value 2)))))
__check_defined = \
		$(if $(value $1),, \
		$(error Undefined $1$(if $2, ($2))))
check_undefined = \
		$(strip $(foreach 1,$1, \
		$(call __check_undefined,$1,$(strip $(value 2)))))
__check_undefined = \
		$(if $(value $1), \
		$(error Defined $1$(if $2, ($2))),)
