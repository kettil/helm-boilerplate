#!/bin/bash
cd "$(dirname "${0}")"

#helm template "app-secrets" . -f secrets.yaml \
#    --namespace app-test --create-namespace \
#    --set env.database.databaseUsername=user \
#    --set env.database.databasePassword=pwd \
#    --debug
#exit

helm upgrade "app-secrets" . --install --atomic --wait --timeout 2m -f secrets.yaml \
    --namespace app-test --create-namespace \
    --set env.database.databaseUsername=user \
    --set env.database.databasePassword=pwd \
    --debug

kubectl get secrets --namespace app-test
