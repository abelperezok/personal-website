# S3_BUCKET := $(S3_BUCKET)
# STACK_NAME := $(STACK_NAME)
REGION = eu-west-1
PACKAGED_TEMPLATE = packaged.yaml
S3_BUCKET = abelperez-temp
STACK_NAME = www-abelperezmartinez-com
TEMPLATE = template.yaml
S3_BUCKET_WEB = www-abelperezmartinez-com-staticsitebucket-fzebgrl9qqrs

SRC = src
PROJECT_NAME = ContactForm
FUNCTION_FOLDER = $(PROJECT_NAME)Function
BASE_OUTPUT_PATH = .aws-sam/build
BUILD_OUTPUT_PATH = $(BASE_OUTPUT_PATH)/$(FUNCTION_FOLDER)
BUILD_OUTPUT_ZIP = $(BUILD_OUTPUT_PATH)/$(PROJECT_NAME).zip

ContactEmail = abelperezok@gmail.com
DomainName = abelperezmartinez.com
SubDomainName = www
CertificateArn = arn:aws:acm:us-east-1:976153948458:certificate/dbde4cf9-5eaa-485c-b070-e230572f78e6
IncludeRedirectToSubDomain = true
LambdaEdgeRedirectFunction = arn:aws:lambda:us-east-1:976153948458:function:abelperezmartinez-base-v2-CloudFrontHttpCanonicalR-10GRJW7WOAW5M

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
	--parameter-overrides ContactEmail=$(ContactEmail) DomainName=$(DomainName) SubDomainName=$(SubDomainName) CertificateArn=$(CertificateArn)

.PHONY: start-api
start-api:
	sam local start-api

.PHONY: frontend
frontend:
	aws s3 sync src/Website/ s3://$(S3_BUCKET_WEB)/ --delete --acl=public-read




