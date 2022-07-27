#
SHELL = /bin/sh
.DEFAULT_GOAL := help

DOCKER_IMAGE_TAG ?= 1.0.1

export SERVICE_NAME=sct_label_utils
export APP_NAME=${SERVICE_NAME}-app
export WEB_NAME=${SERVICE_NAME}-web


define _bumpversion
	# upgrades as $(subst $(1),,$@) version, commits and tags
	@docker run -it --rm -v $(PWD):/sct_label_utils \
		-u $(shell id -u):$(shell id -g) \
		itisfoundation/ci-service-integration-library:v1.0.1-dev-32 \
		sh -c "cd /sct_label_utils && bump2version --verbose --list --config-file $(1) $(subst $(2),,$@)"
endef

.PHONY: version-patch version-minor version-major
version-patch version-minor version-major: .bumpversion.cfg ## increases service's version
	@make compose-spec
	@$(call _bumpversion,$<,version-)
	@make compose-spec


.PHONY: compose-spec
compose-spec: ## runs ooil to assemble the docker-compose.yml file
	@docker run -it --rm -v $(PWD):/sct_label_utils \
		-u $(shell id -u):$(shell id -g) \
		itisfoundation/ci-service-integration-library:v1.0.1-dev-32 \
		sh -c "cd /sct_label_utils && ooil compose"

.PHONY: build
build: compose-spec ## build docker images
	docker-compose build

#.PHONY: run-local
run-local: ## runs images with local configuration. TODO: make application start with inputs provided. Not it just waits for the input
	rm -f sct_label_utils.zip
	smbget -U ${DEVOPS_USER}%${DEVOPS_PASSWORD} smb://biobackup.speag.com/osparc/data/sct_label_utils/sct_label_utils.zip -o sct_label_utils.zip
	unzip -o sct_label_utils.zip -d validation/input
	docker-compose --file docker-compose-local.yml up

.PHONY: shell-app up
shell-app: ## enter app container
	docker run -it --rm --entrypoint /bin/bash simcore/services/dynamic/${APP_NAME}:${DOCKER_IMAGE_TAG}

publish-local:  ## push to local throw away registry to test integration
	@docker tag simcore/services/dynamic/${WEB_NAME}:${DOCKER_IMAGE_TAG} registry:5000/simcore/services/dynamic/${WEB_NAME}:${DOCKER_IMAGE_TAG}
	@docker tag simcore/services/dynamic/${APP_NAME}:${DOCKER_IMAGE_TAG} registry:5000/simcore/services/dynamic/${APP_NAME}:${DOCKER_IMAGE_TAG}
	@docker push registry:5000/simcore/services/dynamic/${WEB_NAME}:${DOCKER_IMAGE_TAG}
	@docker push registry:5000/simcore/services/dynamic/${APP_NAME}:${DOCKER_IMAGE_TAG}

.PHONY: help
help: ## this colorful help
	@echo "Recipes for '$(notdir $(CURDIR))':"
	@echo ""
	@awk 'BEGIN {FS = ":.*?## "} /^[[:alpha:][:space:]_-]+:.*?## / {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""