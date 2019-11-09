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
    create \
		--cluster-config ${PROJ_NAME} \
		--cluster ${PROJ_NAME} \
    --launch-type EC2

deploy: ## Force deployment an ECS service
	ecs-cli compose \
    --project-name ${PROJ_NAME} \
    service start \
		--cluster-config ${PROJ_NAME} \
		--cluster ${PROJ_NAME} \
		--force-deployment

push: ## Push ecr
	ecs-cli push \
		--cluster-config ${PROJ_NAME} \
		${IMG_URI}

local: ## Up local
	IMG_URI=${IMG_URI} \
	IMG_TAG=${IMG_TAG} \
	docker-compose \
		-f docker-compose.yml \
		-f docker-compose-local.yml \
		up --force-recreate
