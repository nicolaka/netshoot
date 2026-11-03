.PHONY: build-x86 build-arm64 build-all push release smoke smoke-debian

IMAGENAME ?= nicolaka/netshoot
VERSION ?= $(shell git describe --tags --always --dirty 2>/dev/null || echo dev)
PLATFORMS ?= linux/amd64,linux/arm64

.DEFAULT_GOAL := build-all

build-x86:
	docker build --platform linux/amd64 --build-arg VERSION=$(VERSION) -t $(IMAGENAME):$(VERSION) .

build-arm64:
	docker build --platform linux/arm64 --build-arg VERSION=$(VERSION) -t $(IMAGENAME):$(VERSION) .

build-all:
	docker buildx build --platform $(PLATFORMS) --build-arg VERSION=$(VERSION) --output "type=image,push=false" --file ./Dockerfile -t $(IMAGENAME):$(VERSION) .

push:
	docker push $(IMAGENAME):$(VERSION)

release:
	docker buildx build --platform $(PLATFORMS) --build-arg VERSION=$(VERSION) --push --file ./Dockerfile \
		-t $(IMAGENAME):$(VERSION) \
		-t $(IMAGENAME):latest .

smoke:
	docker build --platform linux/amd64 --build-arg VERSION=$(VERSION) -t $(IMAGENAME):$(VERSION) .
	docker run --rm --platform linux/amd64 --entrypoint netshoot-smoke $(IMAGENAME):$(VERSION)

smoke-debian:
	docker build --platform linux/amd64 --build-arg VERSION=$(VERSION) -f Dockerfile.debian -t $(IMAGENAME):$(VERSION)-debian .
	docker run --rm --platform linux/amd64 --entrypoint netshoot-smoke $(IMAGENAME):$(VERSION)-debian
