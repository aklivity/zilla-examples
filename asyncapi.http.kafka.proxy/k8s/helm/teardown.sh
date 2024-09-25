#!/bin/sh
set -e

# Stop port forwarding
pgrep kubectl && killall kubectl

# Uninstall Zilla and Kafka
NAMESPACE="${NAMESPACE:-zilla-http-kafka-asyncapi-proxy}"
helm uninstall zilla --namespace $NAMESPACE
kubectl delete namespace $NAMESPACE
