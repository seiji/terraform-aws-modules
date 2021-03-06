SERVICE_NAME=alb-ecs-ec2-staging
TASKDEF_NAME=alb-ecs-ec2-staging
IMG_TAG=latest

.PHONY: help create
.DEFAULT_GOAL := help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST)  \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

ecr_login: ## Login ecr
	aws ecr get-login-password | docker login --username AWS --password-stdin ${IMG_URI}

ecr_logout: ## Logout from ecr
	docker logout ${IMG_URI}

img_build:
	docker-compose build

img_push: img_build ## Push ecr
	docker-compose push

taskdef_create: ## Create an ECS task definition from your compose file.
	$(call taskdef_create,${IMG_URI},${IMG_TAG},${TASKDEF_NAME},docker-compose.yml,ecs-params.yml)

service_update: ## Create a deployment
	$(call service_update,${SERVICE_NAME})

deploy: taskdef_create service_update ## Force deployment an ECS service

deployment_list: ## List developments of a service
	$(call service_deployment_list,${SERVICE_NAME})

local_create: ## Creates a Compose file from remote ECS task definition
	ecs-cli local \
		create \
		--task-def-remote ${TASKDEF_NAME} \

local_up: ## Runs containers locally from an ECS Task Definitio
	@IMG_URI=${IMG_URI} \
	IMG_TAG=${IMG_TAG} \
	ecs-cli local \
    up --task-def-compose docker-compose.ecs-local.yml

local_down: ## Runs containers locally from an ECS Task Definitio
	@ecs-cli local down -all

local_ps: ## Lists locally running ECS task containers
	@ecs-cli local ps -all

define taskdef_create
	@IMG_URI=$(1) \
	IMG_TAG=$(2) \
	ecs-cli \
		compose \
		--project-name $(3) \
		--file $(4) \
		--ecs-params $(5) \
		create \
		--launch-type EC2
endef

define service_update
	$(eval TASKDEF_ARN := $(shell aws ecs describe-task-definition --task-definition $(1) --query "taskDefinition.taskDefinitionArn" --output text))
	@aws ecs \
		update-service \
		--cluster $(1) \
		--service $(1) \
		--task-definition ${TASKDEF_ARN} \
		--force-new-deployment
endef

define service_deployment_list
	@aws ecs \
		describe-services \
		--cluster $(1) \
		--services $(1) \
		--query "services[0].deployments"
endef
