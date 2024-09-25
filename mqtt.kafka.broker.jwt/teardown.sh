#!/bin/sh
set -e

# Stop port forwarding
pgrep kubectl && killall kubectl

# Uninstall Zilla and Kafka
NAMESPACE="${NAMESPACE:-zilla-mqtt-kafka-broker-jwt}"
helm uninstall zilla kafka --namespace $NAMESPACE
kubectl delete namespace $NAMESPACE
