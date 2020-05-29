build:
	@sam build

start:
	@SAM_CLI_TELEMETRY=0 sam local start-api

invoke: build
	@sam local invoke

clean:
	@rm -Rf .aws-sam

deploy: build
	@sam deploy

destroy:
	@aws cloudformation delete-stack --stack-name example-apigw-http

