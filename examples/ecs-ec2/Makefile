PROJ_NAME=ecs-ec2-staging

.PHONY: help create
.DEFAULT_GOAL := help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST)  \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

create: ## Creates an ECS task definition from your compose file.
	ecs-cli compose \
    --project-name ${PROJ_NAME} \
    create \
		--cluster-config ${PROJ_NAME} \
    --launch-type EC2

local:
	docker-compose \
		-f docker-compose.yml \
		-f docker-compose-local.yml \
		up --force-recreate

push:
	ecs-cli push \
		--cluster-config ${PROJ_NAME} \
		752096157676.dkr.ecr.ap-northeast-1.amazonaws.com/ecs-ec2


