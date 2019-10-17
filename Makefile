# Get current directory
DIR := ${CURDIR}

# Credstash version and dowload locations
CREDSTASH_VERSION := 0.4.0
CREDSTASH_DOWNLOAD_DARWIN_URL := https://github.com/sspinc/terraform-provider-credstash/releases/download/$(CREDSTASH_VERSION)/terraform-provider-credstash_darwin_amd64
CREDSTASH_FILEPATH := ~/.terraform.d/plugins/terraform-provider-credstash_v$(CREDSTASH_VERSION)

.PHONY: setup
setup:
	@mkdir -p ~/.terraform.d/plugins
	@curl -L "$(CREDSTASH_DOWNLOAD_DARWIN_URL)" -o $(CREDSTASH_FILEPATH) -z $(CREDSTASH_FILEPATH)
	@chmod +x ~/.terraform.d/plugins/terraform-provider-credstash_v$(CREDSTASH_VERSION)

.PHONY: clean
clean:
	@rm -rf .terraform

.PHONY: fmt
fmt:
	@terraform fmt --recursive

.PHONY: init
init:
	@terraform init -backend-config=backend.tfvars  -backend-config=credentials=$(GOOGLE_APPLICATION_CREDENTIALS_PATH) 

.PHONY: validate
validate:
	@terraform validate .

.PHONY: semantic-release
semantic-release:
	npm install
	npx semantic-release

.PHONY: semantic-release-dry-run
semantic-release-dry-run:
	npm install
	npx semantic-release -d