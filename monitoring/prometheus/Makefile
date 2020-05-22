.PHONY: help build push build_and_push

help: ## show help
	@echo 'usage: make [target] ...'
	@echo ''
	@echo 'targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

build: ## build
	@echo 'build'
	docker build --rm --no-cache -t souljapanic/prometheus .

push: ## push
	@echo 'build'
	docker push souljapanic/prometheus

build_and_push: build push ## build and push

default:
	help
