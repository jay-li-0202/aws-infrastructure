default: help

ACTION ?= validate

STATE_BUCKET ?= basisregisters-aws-state

.PHONY: validate
validate:
	@$(eval TF_DIRECTORIES := $(shell find . -type f -name "*.tf" -exec dirname {} \; | sort -u))
	@$(foreach var, $(TF_DIRECTORIES), terraform validate -check-variables=false "$(var)" && echo "√ $(var)";)

.PHONY: format
format:
	@$(eval TF_DIRECTORIES := $(shell find . -type f -name "*.tf" -exec dirname {} \; | sort -u))
	@$(foreach var, $(TF_DIRECTORIES), terraform fmt "$(var)" && echo "√ $(var)";)

.PHONY: init
init: ## Init Terraform configs
	$(call check_undefined, AWS_PROFILE, AWS Profile should not be defined)
	$(call check_defined, ENVIRONMENT, Environment to use, 'staging' or 'production')
	@find -type d -name ".terraform" -exec rm -rf {} \;
	@cd environment/roots/account_bootstrap && terraform init -upgrade -backend-config=../../../$(ENVIRONMENT)-backend.tfvars
	@cd environment/roots/base_vpc && terraform init -upgrade -backend-config=../../../$(ENVIRONMENT)-backend.tfvars
	@cd environment/roots/dns && terraform init -upgrade -backend-config=../../../$(ENVIRONMENT)-backend.tfvars
	@cd environment/roots/docker_repo && terraform init -upgrade -backend-config=../../../$(ENVIRONMENT)-backend.tfvars
	@cd environment/roots/elasticsearch && terraform init -upgrade -backend-config=../../../$(ENVIRONMENT)-backend.tfvars

.PHONY: destroy
destroy: ## Destroy infrastructure created by Terraform
	$(call check_undefined, AWS_PROFILE, AWS Profile should not be defined)
	$(call check_defined, ENVIRONMENT, Environment to use, 'staging' or 'production')
	@cd environment/roots/elasticsearch && terraform destroy -var "state_bucket=$(STATE_BUCKET)"
	@cd environment/roots/docker_repo && terraform destroy -var "state_bucket=$(STATE_BUCKET)"
	# @cd environment/roots/dns && terraform destroy -var "state_bucket=$(STATE_BUCKET)"
	@cd environment/roots/base_vpc && terraform destroy -var "state_bucket=$(STATE_BUCKET)"
	# @cd environment/roots/account_bootstrap && terraform destroy -var "state_bucket=$(STATE_BUCKET)"

.PHONY: help
help: ## Display this information. Default target.
	@echo "Valid targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

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
