default: help

ACTION ?= validate
REPOSITORY ?= basisregisters
DOCKERHUB_REPOSITORY ?= basisregisters

##############

.PHONY: bastion
bastion: ## Create a Docker image which serves as a bastion
	$(call check_undefined, AWS_PROFILE, AWS Profile should not be defined)
	$(call check_defined, ACTION, Packer action to perform)
	$(call check_defined, ENVIRONMENT, Environment to use, 'staging' or 'production')
	$(call check_defined, DOCKERHUB_USER, DockerHub username to use)
	$(call check_defined, DOCKERHUB_PASS, DockerHub password to use)
	@cd bastion && \
		packer $(ACTION) \
			-var 'image=bastion' \
			-var 'repository=$(REPOSITORY)' \
			-var 'dockerhub_repository=$(DOCKERHUB_REPOSITORY)' \
			-var 'dockerhub_user=$(DOCKERHUB_USER)' \
			-var 'dockerhub_pass=$(DOCKERHUB_PASS)' \
			bastion.json

##############

.PHONY: build-agent
build-agent: ## Create a Docker image which serves as a base build images
	$(call check_undefined, AWS_PROFILE, AWS Profile should not be defined)
	$(call check_defined, ACTION, Packer action to perform)
	$(call check_defined, ENVIRONMENT, Environment to use, 'staging' or 'production')
	$(call check_defined, DOCKERHUB_USER, DockerHub username to use)
	$(call check_defined, DOCKERHUB_PASS, DockerHub password to use)
	@cd build-agent && \
		packer $(ACTION) \
			-var 'image=build-agent' \
			-var 'repository=$(REPOSITORY)' \
			-var 'dockerhub_repository=$(DOCKERHUB_REPOSITORY)' \
			-var 'dockerhub_user=$(DOCKERHUB_USER)' \
			-var 'dockerhub_pass=$(DOCKERHUB_PASS)' \
			build-agent.json

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
