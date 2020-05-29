.PHONY: build clean start invoke

build:
	@sam build

start:
	@SAM_CLI_TELEMETRY=0 sam local start-api

invoke: build
	@sam local invoke

clean:
	@rm -Rf .aws-sam

deploy: clean build
	@sam deploy
