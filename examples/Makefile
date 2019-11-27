.PHONY: clean validate
.DEFAULT_GOAL := help

help:
	echo "help"

validate:
	@terragrunt validate-all

clean:
	@find . -type d -name '.terragrunt-cache' -prune -exec rm -rf {} \;
	@find . -type d -name '.terraform' -prune -exec rm -rf {} \;

destroy:
	@terragrunt destroy-all

list:
	@find . -type f -name '*.hcl'
