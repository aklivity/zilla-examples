#!/bin/sh
set -e

# Stop port forwarding
pgrep kubectl && killall kubectl

# Uninstall Zilla and Kafka
NAMESPACE="${NAMESPACE:-zilla-http-kafka-sasl-scram}"
helm uninstall zilla kafka --namespace $NAMESPACE
kubectl delete namespace $NAMESPACE
