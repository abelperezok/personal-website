# S3_BUCKET := $(S3_BUCKET)
# STACK_NAME := $(STACK_NAME)
REGION = eu-west-1
PACKAGED_TEMPLATE = packaged.yaml
S3_BUCKET = abelperez-temp
STACK_NAME = web-abelperez-info
TEMPLATE = template.yaml

SRC = src
PROJECT_NAME = ContactForm
FUNCTION_FOLDER = $(PROJECT_NAME)Function
BASE_OUTPUT_PATH = .aws-sam/build
BUILD_OUTPUT_PATH = $(BASE_OUTPUT_PATH)/$(FUNCTION_FOLDER)
BUILD_OUTPUT_ZIP = $(BUILD_OUTPUT_PATH)/$(PROJECT_NAME).zip

# DomainName = abelperez.info
# CertificateArn = arn:aws:acm:us-east-1:976153948458:certificate/1bfd9f67-8a7e-4aa6-b07e-06cea2308acf
# --parameter-overrides DomainName=$(DomainName) CertificateArn=$(CertificateArn)
ContactEmail = abelperezok@gmail.com

.PHONY: clean
clean:
	rm -rf ./.aws-sam/

.PHONY: build
build: clean
	dotnet lambda package --project-location $(SRC)/$(PROJECT_NAME)/ $(BUILD_OUTPUT_ZIP)
	unzip -o $(BUILD_OUTPUT_ZIP) -d $(BUILD_OUTPUT_PATH)
	rm $(BUILD_OUTPUT_ZIP)

.PHONY: package
package:
	sam package --s3-bucket $(S3_BUCKET) --s3-prefix $(STACK_NAME) --output-template-file $(BASE_OUTPUT_PATH)/packaged.yaml

.PHONY: deploy
deploy: package
	sam deploy --template-file $(BASE_OUTPUT_PATH)/packaged.yaml --stack-name $(STACK_NAME) \
	--s3-bucket $(S3_BUCKET) --s3-prefix $(STACK_NAME) \
	--region $(REGION) --capabilities CAPABILITY_IAM \
	--parameter-overrides ContactEmail=$(ContactEmail)

.PHONY: start-api
start-api:
	sam local start-api






