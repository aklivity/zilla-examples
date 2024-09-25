#!/bin/sh
set -e

# Stop port forwarding
pgrep kubectl && killall kubectl

# Uninstall Zilla and SSE Server
NAMESPACE="${NAMESPACE:-zilla-sse-proxy-jwt}"
helm uninstall zilla sse-server --namespace $NAMESPACE
kubectl delete namespace $NAMESPACE
