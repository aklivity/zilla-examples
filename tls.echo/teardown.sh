#!/bin/sh
set -e

# Stop port forwarding
pgrep kubectl && killall kubectl

# Uninstall Zilla engine
NAMESPACE="${NAMESPACE:-zilla-tls-echo}"
helm uninstall zilla --namespace $NAMESPACE
kubectl delete namespace $NAMESPACE
