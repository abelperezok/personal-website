# How to update Base infrastructure Lambda@Edge runtime

1. Update `base-infra.yaml` template:

* Resources.CloudFrontHttpCanonicalRedirect.Runtime to the new runtime
* Increase the version number Resources.LambdaEdgeRedirectFunctionVersion4 
* Update the description Description: Version 4"
* Update Outputs.LambdaEdgeRedirectFunctionVersion.Value
* Update Outputs.LambdaEdgeRedirectFunctionIncludingVersion.Value

2. Set all the variables

    ```shell
    BASE_STACK_NAME=abelperezmartinez-base-v2
    DOMAIN_NAME=abelperezmartinez.com
    SUB_DOMAIN_NAME=www
    INCLUDE_REDIRECT=true
    SSL_CERT_ARN=
    HOSTED_ZONE_ID=ZNKSSIFWUTKP6
    ```

    It's important to keep certificate ARN empty as it will be continue to create it and won't try to delete it.

3. Deploy `base-infra.yaml`

    ```shell
    aws cloudformation deploy --stack-name $BASE_STACK_NAME \
    --template-file base-infra.yaml \
    --capabilities CAPABILITY_IAM \
    --parameter-overrides \
    DomainName=$DOMAIN_NAME \
    SubDomainName=$SUB_DOMAIN_NAME \
    SSLCertificateArn=$SSL_CERT_ARN \
    IncludeRedirectToSubDomain=$INCLUDE_REDIRECT \
    HostedZoneId=$HOSTED_ZONE_ID \
    --region us-east-1
    ```
4. Update `Makefile` 

* LambdaEdgeRedirectFunction should point to the latest version of the Lambda function