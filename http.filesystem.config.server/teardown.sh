#!/bin/sh
set -e

# Stop port forwarding
pgrep kubectl && killall kubectl

# Uninstall Zilla engine
NAMESPACE="${NAMESPACE:-zilla-config-server}"
helm uninstall zilla-config zilla-http --namespace $NAMESPACE
kubectl delete namespace $NAMESPACE
