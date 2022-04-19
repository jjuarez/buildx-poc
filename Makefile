#!/usr/bin/env make

.DEFAULT_GOAL  := help
.DEFAULT_SHELL := /bin/bash

OUTPUT := myapp

define assert-set
	@$(if $($1),,$(error $(1) environment variable is not defined))
endef

define assert-command
	@$(if $(shell command -v $1 2>/dev/null),,$(error $1 command not found))
endef


.PHONY: help
help: ## Shows this pretty help screen
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make <target>\n\nTargets:\n"} /^[a-zA-Z//_-]+:.*?##/ { printf " %-20s %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

$(OUTPUT):
	@go build -o $(OUTPUT) .

.PHONY: clean
clean: ## Clean all the stuff
	@rm -f $(OUTPUT)

.PHONY: build
build: $(OUTPUT) ## Build the program

.PHONY: docker/build
docker/build: ## Builds the docker image
	@docker buildx build \
		--cache-from docker.io/jjuarez/buildx-poc:latest \
		--cache-to type=inline \
		--tag jjuarez/buildx-poc:latest \
		--push \
		--file Dockerfile \
		.
