PROJ_NAME=ecs-ec2-staging
IMG_URI=752096157676.dkr.ecr.ap-northeast-1.amazonaws.com/ecs-ec2
IMG_TAG=latest

.PHONY: help create
.DEFAULT_GOAL := help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST)  \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

create: ## Create an ECS task definition from your compose file.
	IMG_URI=${IMG_URI} \
	IMG_TAG=${IMG_TAG} \
	ecs-cli compose \
    --project-name ${PROJ_NAME} \
		--file docker-compose.ecs-local.yml \
    create \
		--cluster ${PROJ_NAME} \
    --launch-type EC2

deploy: ## Force deployment an ECS service
	ecs-cli compose \
    --project-name ${PROJ_NAME} \
		--file docker-compose.ecs-local.yml \
    service start \
		--cluster ${PROJ_NAME} \
		--force-deployment

pull: ## Creates a Compose file from remote ECS task definition
	ecs-cli local \
    create \
		--task-def-remote ${PROJ_NAME} \

up: ## Runs containers locally from an ECS Task Definitio
	@IMG_URI=${IMG_URI} \
	IMG_TAG=${IMG_TAG} \
	ecs-cli local \
    up --task-def-compose docker-compose.ecs-local.yml

down: ## Runs containers locally from an ECS Task Definitio
	@ecs-cli local \
    down -all

ps: ## Lists locally running ECS task containers
	@ecs-cli local \
    ps -all

push_img: ## Push ecr
	ecs-cli push \
		${IMG_URI}

