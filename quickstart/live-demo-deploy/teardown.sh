#!/bin/bash
set -e

## Setting up env
if [ -f .env ]; then
    set -a
    source .env
    set +a
fi

# Uninstall services and namespace
NAMESPACE="${NAMESPACE:-zilla-quickstart}"
ZILLA_NAME="${ZILLA_NAME:-zilla-proxy}"
# uncomment when resources are seperated in different namespaces
# helm uninstall $ZILLA_NAME -n $NAMESPACE
kubectl delete all -n $NAMESPACE --all
kubectl delete namespace $NAMESPACE
