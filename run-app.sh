#!/bin/bash
cd "$(dirname "${0}")"

#helm template "app" . -f values-app.yaml \
#    --namespace app-test --create-namespace \
#    --debug
#exit

helm upgrade "app" . --install --atomic --wait --timeout 2m \
    --namespace app-test --create-namespace \
    -f values-app.yaml \
    --debug

kubectl get ingress,service,cm,secrets,pod,replicaset --namespace app-test
