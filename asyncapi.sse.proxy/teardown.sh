#!/bin/bash
set -x

# Stop port forwarding
pgrep kubectl && killall kubectl

# Uninstall Zilla and SSE Server
NAMESPACE="${NAMESPACE:-zilla-asyncapi-sse-proxy}"
helm uninstall zilla sse-server --namespace $NAMESPACE
kubectl delete namespace $NAMESPACE
