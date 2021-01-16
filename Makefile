## Name of the image
DOCKER_IMAGE=dsuite/goss

## Current directory
DIR:=$(strip $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST)))))

## Define the latest version
latest = 0.3.16

##
.DEFAULT_GOAL := build
.PHONY: *

help:
	@printf "\033[33mUsage:\033[0m\n  make [target]\n\n\033[33mTargets:\033[0m\n"
	@grep -E '^[-a-zA-Z0-9_\.\/]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[32m%-15s\033[0m %s\n", $$1, $$2}'


all: ## Build and test
	@$(MAKE) build
	@$(MAKE) test

build: ## Build Docker image
	@docker build \
		--file Dockerfile \
		--tag $(DOCKER_IMAGE):$(latest) \
		.
	@docker tag $(DOCKER_IMAGE):$(latest) $(DOCKER_IMAGE):latest

test: ## Test Docker image
	# Test image
	@docker run --rm -t \
		-v $(DIR)/goss.yaml:/goss/goss.yaml:ro \
		-v /tmp:/tmp \
		-v /var/run/docker.sock:/var/run/docker.sock \
		dsuite/goss:latest \
		dgoss run $(DOCKER_IMAGE):$(latest) tail -f /dev/null

push:
	@$(MAKE) build
	@docker push $(DOCKER_IMAGE):$(latest)
	@docker push $(DOCKER_IMAGE):latest

shell:
	@docker run --rm -it \
		-v $(DIR)/goss.yaml:/goss/goss.yaml:ro \
		-v /tmp:/tmp \
		-v /var/run/docker.sock:/var/run/docker.sock \
		dsuite/goss:latest \
		bash

readme:
	@docker run -t --rm \
		-e DEBUG_LEVEL=DEBUG \
		-e DOCKER_USERNAME=${DOCKER_USERNAME} \
		-e DOCKER_PASSWORD=${DOCKER_PASSWORD} \
		-e DOCKER_IMAGE=${DOCKER_IMAGE} \
		-v $(DIR):/data \
		dsuite/hub-updater
