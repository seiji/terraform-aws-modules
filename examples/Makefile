.PHONY: clean validate
.DEFAULT_GOAL := help

help:
	echo "help"

validate:
	@terragrunt validate-all

clean:
	@find . -type d -name '.terragrunt-cache' -exec rm -rf {} +
	@find . -type d -name '.terraform' -exec rm -rf {} +

list:
	@find . -type f -name '*.hcl'
