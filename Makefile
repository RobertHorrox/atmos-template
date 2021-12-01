export APP_NAME = <#.cfg.app_name#>
export DOCKER_ORG ?= <#.cfg.docker_org#>
export DOCKER_IMAGE ?= $(DOCKER_ORG)/<#.cfg.docker_image_name#>
export DOCKER_TAG ?= latest
export DOCKER_IMAGE_NAME ?= $(DOCKER_IMAGE):$(DOCKER_TAG)
GEODESIC_INSTALL_PATH ?= /usr/local/bin
export INSTALL_PATH ?= $(GEODESIC_INSTALL_PATH)
export SCRIPT = $(INSTALL_PATH)/$(APP_NAME)

-include $(shell curl -sSL -o .build-harness "https://git.io/build-harness"; echo .build-harness)

## Initialize build-harness, install deps, build docker container, install wrapper script and run shell
all: init deps build install run
	@exit 0

## Install dependencies (if any)
deps:
	@exit 0

## Build docker image
build:
	@make --no-print-directory docker/build

## Push docker image to registry
push:
	docker push $(DOCKER_IMAGE)

## Install wrapper script from geodesic container
install:
	@docker run --rm $(DOCKER_IMAGE_NAME) | bash -s $(DOCKER_TAG) || (echo "Try: sudo make install"; exit 1)

## Start the geodesic shell by calling wrapper script
run:
	$(SCRIPT)

## Rebuild README for all Terraform components
rebuild-docs: packages/install/terraform-docs
	@pre-commit run --all-files terraform_docs
