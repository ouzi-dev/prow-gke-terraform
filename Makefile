# Get current directory
DIR := ${CURDIR}

.PHONY: clean
clean:
	@rm -rf .terraform

.PHONY: fmt
fmt:
	@terraform fmt --recursive

.PHONY: init
init:
	@terraform init

.PHONY: validate
validate:
	@terraform validate .

.PHONY: semantic-release
semantic-release:
	npm ci
	npx semantic-release

.PHONY: semantic-release-dry-run
semantic-release-dry-run:
	npm ci
	npx semantic-release -d

package-lock.json: package.json
	npm install