.PHONY: clean init plan apply destroy format validate bootstrap-init bootstrap-plan bootstrap-apply bootstrap-destroy

# Get current directory
DIR := ${CURDIR}

# Credstash version and dowload locations
CREDSTASH_VERSION := 0.4.0
CREDSTASH_DOWNLOAD_DARWIN_URL := https://github.com/sspinc/terraform-provider-credstash/releases/download/$(CREDSTASH_VERSION)/terraform-provider-credstash_darwin_amd64
CREDSTASH_FILEPATH := ~/.terraform.d/plugins/terraform-provider-credstash_v$(CREDSTASH_VERSION)

setup:
	@mkdir -p ~/.terraform.d/plugins
	@curl -L "$(CREDSTASH_DOWNLOAD_DARWIN_URL)" -o $(CREDSTASH_FILEPATH) -z $(CREDSTASH_FILEPATH)
	@chmod +x ~/.terraform.d/plugins/terraform-provider-credstash_v$(CREDSTASH_VERSION)

clean:
	@rm -rf .terraform

fmt:
	@terraform fmt --recursive
	
init:
	@terraform init -backend-config=backend.tfvars  -backend-config=credentials=$(GOOGLE_APPLICATION_CREDENTIALS_PATH) 

validate:
	@terraform validate .
