#!/bin/sh
set -e

# Stop port forwarding
pgrep kubectl && killall kubectl

# Uninstall Zilla and Nginx
NAMESPACE="${NAMESPACE:-zilla-http-proxy}"
helm uninstall zilla nginx --namespace $NAMESPACE
kubectl delete namespace $NAMESPACE
