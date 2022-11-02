TAG ?= latest
REGISTRY_ID ?= 089370973671
REPOSITORY_REGION ?= eu-central-1
APP_NAME ?= kebap
ENV_NAME ?= project
REPO_NAME ?= 089370973671.dkr.ecr.eu-central-1.amazonaws.com/awsecr120860019576

.PHONY: build
build:
	$(MAKE) docker-login
	docker build -t $(REPO_NAME):$(TAG) -f ./Dockerfile .
	docker push $(REPO_NAME):$(TAG)

.PHONY: docker-login
docker-login:
	aws ecr get-login-password --region $(REPOSITORY_REGION) | docker login --username AWS --password-stdin $(REGISTRY_ID).dkr.ecr.$(REPOSITORY_REGION).amazonaws.com
