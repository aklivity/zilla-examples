#!/bin/sh
set -e

# Stop port forwarding
pgrep kubectl && killall kubectl

# Uninstall Zilla and Kafka
NAMESPACE="${NAMESPACE:-zilla-asyncapi-mqtt-kafka-proxy}"
helm uninstall zilla --namespace $NAMESPACE
kubectl delete namespace $NAMESPACE
