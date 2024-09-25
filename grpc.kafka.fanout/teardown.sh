#!/bin/sh
set -e

# Stop port forwarding
pgrep kubectl && killall kubectl

# Uninstall Zilla and Kafka
NAMESPACE="${NAMESPACE:-zilla-grpc-kafka-fanout}"
helm uninstall zilla kafka --namespace $NAMESPACE
kubectl delete namespace $NAMESPACE
