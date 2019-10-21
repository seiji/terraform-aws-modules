.PHONY: all
.DEFAULT_GOAL := plan

config:
	terraform remote config \
		-backend=s3 \
		-backend-config='bucket=terraform-aws-modules-tfstate' \
		-backend-config='key=v000800/development/terraform.tfstate'

plan: config
	rm -rf .terraform/modules && terraform get && terraform plan
apply:
	terraform apply
