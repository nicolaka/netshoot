IMAGE_REPO=localhost
IMAGE_NAME=netshoot
IMAGE_TAG=master
CONTAINER_NAME=netshoot

.DEFAULT_GOAL:=help
SHELL:=/bin/bash

.PHONY: help build-buildah build-docker

help: ## Display help information
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n\nTargets:\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

build-buildah: ## Build OCI image with Buildah
	buildah bud -t $(IMAGE_REPO)/$(IMAGE_NAME):$(IMAGE_TAG) .
	buildah images

build-docker: ## Build Docker image with Docker
	docker build -t $(IMAGE_REPO)/$(IMAGE_NAME):$(IMAGE_TAG) .
	docker images

