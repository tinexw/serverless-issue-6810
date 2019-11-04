#!/bin/bash
set -euo pipefail

# Deploy Api Gateway
sls deploy --config api-gateway.yaml
query='Exports[?Name==`'MyApiGateway-restApiId'`].[Value]' 
rootId=`aws cloudformation list-exports  --output text --no-paginate --query $query` 

rm -rf resources-*.yml 

# Deploy /bar/baz - 1st run
echo "== Deploying bar/baz - 1st run =="
aws apigateway get-resources  --rest-api-id $rootId --query='items[?path!=`/bar/baz`].[path,id]'  --output text | sort |  gsed '1d' | gsed 's/\t/: /' | gsed 's:^/::'   > resources-service-bar-baz.yml 
echo "-- apiGateway.restApiResources --"
cat resources-service-bar-baz.yml 
echo "---------------------------------"
sls deploy  --config service-bar-baz.yaml
echo "------ Available resources ------"
aws apigateway get-resources --rest-api-id $rootId --query=items[].[path,id] --output text
echo "---------------------------------"
echo "================================="


# Deploy /bar/baz2 - 1st run
echo "== Deploying bar/baz2 - 1st run =="
aws apigateway get-resources  --rest-api-id $rootId --query='items[?path!=`/bar/baz2`].[path,id]'  --output text | sort |  gsed '1d' | gsed 's/\t/: /' | gsed 's:^/::'   > resources-service-bar-baz2.yml 
echo "-- apiGateway.restApiResources --"
cat resources-service-bar-baz2.yml 
echo "---------------------------------"
sls deploy  --config service-bar-baz2.yaml
echo "------ Available resources ------"
aws apigateway get-resources --rest-api-id $rootId --query=items[].[path,id] --output text
echo "---------------------------------"
echo "================================="


rm -rf resources-*.yml 

# Deploy /foo
echo "========= Deploying foo ========="
aws apigateway get-resources  --rest-api-id $rootId --query='items[?path!=`/foo`].[path,id]'  --output text | sort |  gsed '1d' | gsed 's/\t/: /' | gsed 's:^/::'   > resources-service-foo.yml 
echo "-- apiGateway.restApiResources --"
cat resources-service-foo.yml 
echo "---------------------------------"
sls deploy  --config service-foo.yaml
echo "------ Available resources ------"
aws apigateway get-resources --rest-api-id $rootId --query=items[].[path,id] --output text
echo "---------------------------------"
echo "================================="


rm -rf resources-*.yml 

# Deploy /bar/baz - 2nd  run
echo "== Deploying bar/baz - 2nd run =="
aws apigateway get-resources  --rest-api-id $rootId --query='items[?path!=`/bar/baz`].[path,id]'  --output text | sort |  gsed '1d' | gsed 's/\t/: /' | gsed 's:^/::'     > resources-service-bar-baz.yml 
echo "-- apiGateway.restApiResources --"
cat resources-service-bar-baz.yml 
echo "---------------------------------"
sls deploy  --config service-bar-baz.yaml
echo "------ Available resources ------"
aws apigateway get-resources --rest-api-id $rootId --query=items[].[path,id] --output text
echo "---------------------------------"
echo "================================="


rm -rf resources-*.yml 


# Deploy /bar/baz - 3rd  run
echo "== Deploying bar/baz - 3rd run =="
aws apigateway get-resources  --rest-api-id $rootId --query='items[?path!=`/bar/baz`].[path,id]'  --output text | sort |  gsed '1d' | gsed 's/\t/: /' | gsed 's:^/::'     > resources-service-bar-baz.yml 
echo "-- apiGateway.restApiResources --"
cat resources-service-bar-baz.yml 
echo "---------------------------------"
sls deploy  --config service-bar-baz.yaml
echo "------ Available resources ------"
aws apigateway get-resources --rest-api-id $rootId --query=items[].[path,id] --output text
echo "---------------------------------"
echo "================================="

serverless remove --config service-foo.yaml
serverless remove --config service-bar-baz.yaml
serverless remove --config service-bar-baz2.yaml
serverless remove --config api-gateway.yaml