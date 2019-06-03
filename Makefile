DOCKER_ORG ?= dsuite
DOCKER_REPO := goss

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
		--tag $(DOCKER_ORG)/$(DOCKER_REPO):0.3.7 .
	# Set dsuite/goss:0.3.7 as lastest
	docker tag $(DOCKER_ORG)/$(DOCKER_REPO):0.3.7 $(DOCKER_ORG)/$(DOCKER_REPO):latest

test-0.3.7:
	# Test image
	docker run --rm -t \
		-e http_proxy=${http_proxy} \
		-e https_proxy=${https_proxy} \
		-v "${PWD}/goss.yaml:/goss/goss.yaml:ro" \
		-v /tmp:/tmp \
		-v /var/run/docker.sock:/var/run/docker.sock \
		dsuite/goss:latest \
		dgoss run $(DOCKER_ORG)/$(DOCKER_REPO):0.3.7 tail -f /dev/null