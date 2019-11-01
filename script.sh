#!/bin/bash
set -euo pipefail

# Deploy Api Gateway
sls deploy --config api-gateway.yaml
query='Exports[?Name==`'MyApiGateway-restApiId'`].[Value]' 
rootId=`aws cloudformation list-exports  --output text --no-paginate --query $query` 

rm -rf resources-*.yml 

# Deploy /bar - 1st run
echo "==== Deploying bar - 1st run ===="
aws apigateway get-resources  --rest-api-id $rootId --query=items[].[path,id]  --output text | sort |  gsed '1d' | gsed 's/\t/: /' | gsed 's:^/::'   > resources-service-bar.yml 
echo "-- apiGateway.restApiResources --"
cat resources-service-bar.yml 
echo "---------------------------------"
sls deploy  --config service-bar.yaml
echo "------ Available resources ------"
aws apigateway get-resources --rest-api-id $rootId --query=items[].[path,id] --output text
echo "---------------------------------"
echo "================================="


rm -rf resources-*.yml 

# Deploy /foo
echo "========= Deploying foo ========="
aws apigateway get-resources  --rest-api-id $rootId --query=items[].[path,id]  --output text | sort |  gsed '1d' | gsed 's/\t/: /' | gsed 's:^/::'   > resources-service-foo.yml 
echo "-- apiGateway.restApiResources --"
cat resources-service-foo.yml 
echo "---------------------------------"
sls deploy  --config service-foo.yaml
echo "------ Available resources ------"
aws apigateway get-resources --rest-api-id $rootId --query=items[].[path,id] --output text
echo "---------------------------------"
echo "================================="


rm -rf resources-*.yml 

# Deploy /bar - 2nd  run
echo "==== Deploying bar - 2nd run ===="
aws apigateway get-resources  --rest-api-id $rootId --query=items[].[path,id]  --output text | sort |  gsed '1d' | gsed 's/\t/: /' | gsed 's:^/::'     > resources-service-bar.yml 
echo "-- apiGateway.restApiResources --"
cat resources-service-bar.yml 
echo "---------------------------------"
sls deploy  --config service-bar.yaml
echo "------ Available resources ------"
aws apigateway get-resources --rest-api-id $rootId --query=items[].[path,id] --output text
echo "---------------------------------"
echo "================================="


rm -rf resources-*.yml 

# Deploy /bar - 3rd run
echo "==== Deploying bar - 3rd run ===="
aws apigateway get-resources  --rest-api-id $rootId --query=items[].[path,id]  --output text | sort |  gsed '1d' | gsed 's/\t/: /' | gsed 's:^/::'  > resources-service-bar.yml 
echo "-- apiGateway.restApiResources --"
cat resources-service-bar.yml 
echo "---------------------------------"
sls deploy  --config service-bar.yaml
echo "------ Available resources ------"
aws apigateway get-resources --rest-api-id $rootId --query=items[].[path,id] --output text
echo "---------------------------------"
echo "================================="

serverless remove --config service-foo.yaml
serverless remove --config service-bar.yaml
serverless remove --config api-gateway.yaml