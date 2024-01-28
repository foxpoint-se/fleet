SHELL = /bin/bash

.PHONY: help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help

.PHONY: setup-deploy
setup-deploy:
	cd deploy && yarn

.PHONY: setup
setup: setup-deploy		## install and setup everything for development

.PHONY: cdk-deploy
cdk-deploy:
	cd deploy && yarn cdk deploy

.PHONY: deploy
deploy: setup cdk-deploy-web		## deploy web app