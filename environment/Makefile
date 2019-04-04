default: help

ACTION ?= plan

##############

roots/state_bootstrap/.terraform/terraform.tfstate:
	@cd roots/state_bootstrap && \
		terraform init

.PHONY: state-bootstrap
state-bootstrap: roots/state_bootstrap/.terraform/terraform.tfstate ## Run Terraform to bootstrap remote state bucket
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
