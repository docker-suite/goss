DOCKER_IMAGE=dsuite/goss
DIR:=$(strip $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST)))))

all: build test

# Build Docker image
build: build-0.3.7

# Test Docker image
test: test-0.3.7

build-0.3.7:
	# Build dsuite/goss:0.3.7
	docker build \
		--build-arg http_proxy=${http_proxy} \
		--build-arg https_proxy=${https_proxy} \
		--file Dockerfile-0.3.7 \
		--tag $(DOCKER_IMAGE):0.3.7 \
		.
	# Set dsuite/goss:0.3.7 as lastest
	docker tag $(DOCKER_IMAGE):0.3.7 $(DOCKER_IMAGE):latest

test-0.3.7:
	# Test image
	docker run --rm -t \
		-e http_proxy=${http_proxy} \
		-e https_proxy=${https_proxy} \
		-v $(DIR)/goss.yaml:/goss/goss.yaml:ro \
		-v /tmp:/tmp \
		-v /var/run/docker.sock:/var/run/docker.sock \
		dsuite/goss:latest \
		dgoss run $(DOCKER_IMAGE):0.3.7 tail -f /dev/null

shell-0.3.7:
	# Test image
	docker run --rm -it \
		-e http_proxy=${http_proxy} \
		-e https_proxy=${https_proxy} \
		-v $(DIR)/goss.yaml:/goss/goss.yaml:ro \
		-v /tmp:/tmp \
		-v /var/run/docker.sock:/var/run/docker.sock \
		dsuite/goss:latest \
		bash

readme:
	@docker run -t --rm \
		-e http_proxy=${http_proxy} \
		-e https_proxy=${https_proxy} \
		-e DEBUG_LEVEL=DEBUG \
		-e DOCKER_USERNAME=${DOCKER_USERNAME} \
		-e DOCKER_PASSWORD=${DOCKER_PASSWORD} \
		-e DOCKER_IMAGE=${DOCKER_IMAGE} \
		-v $(DIR):/data \
		dsuite/hub-updater
