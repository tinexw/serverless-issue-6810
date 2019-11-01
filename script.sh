#!/bin/bash
set -euo pipefail

# Deploy Api Gateway
sls deploy --config api-gateway.yaml
query='Exports[?Name==`'MyApiGateway-restApiId'`].[Value]' 
rootId=`aws cloudformation list-exports  --output text --no-paginate --query $query` 

rm -rf resources-*.yml 

# Deploy /bar - 1st run
echo "Deploying /bar - 1st run"
aws apigateway get-resources  --rest-api-id $rootId --query=items[].[path,id]  --output text | sort |  gsed '1d' | gsed 's/\t/: /' | gsed 's:^/::'  > resources-service-bar.yml 
cat resources-service-bar.yml 
sls deploy  --config service-bar.yaml
echo "Resources after deploying /bar - 1st run:"
aws apigateway get-resources --rest-api-id $rootId --query=items[].[path,id] --output text

rm -rf resources-*.yml 

# Deploy /foo
echo "Deploying /foo"
aws apigateway get-resources  --rest-api-id $rootId --query=items[].[path,id]  --output text | sort |  gsed '1d' | gsed 's/\t/: /' | gsed 's:^/::'  > resources-service-foo.yml 
cat resources-service-foo.yml 
sls deploy  --config service-foo.yaml
echo "Resources after deploying /foo:"
aws apigateway get-resources --rest-api-id $rootId --query=items[].[path,id] --output text

rm -rf resources-*.yml 

# Deploy /bar - 2nd  run
echo "Deploying /bar - 2nd run"
aws apigateway get-resources  --rest-api-id $rootId --query=items[].[path,id]  --output text | sort |  gsed '1d' | gsed 's/\t/: /' | gsed 's:^/::'  > resources-service-bar.yml 
cat resources-service-bar.yml 
sls deploy  --config service-bar.yaml
echo "Resources after deploying /bar - 2nd run:"
aws apigateway get-resources --rest-api-id $rootId --query=items[].[path,id] --output text

rm -rf resources-*.yml 

# Deploy /bar - 3rd run
echo "/Deploying bar - 3rd run"
aws apigateway get-resources  --rest-api-id $rootId --query=items[].[path,id]  --output text | sort |  gsed '1d' | gsed 's/\t/: /' | gsed 's:^/::'  > resources-service-bar.yml 
cat resources-service-bar.yml 
sls deploy  --config service-bar.yaml
echo "Resources after deploying /bar - 3rd run:"
aws apigateway get-resources --rest-api-id $rootId --query=items[].[path,id] --output text


serverless remove --config service-foo.yaml
serverless remove --config service-bar.yaml
serverless remove --config api-gateway.yaml