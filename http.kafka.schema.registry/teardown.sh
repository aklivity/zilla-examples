#!/bin/bash
set -x

# Stop port forwarding
pgrep kubectl && killall kubectl

# Uninstall Zilla and Kafka
helm uninstall zilla-http-kafka-schema-registry zilla-http-kafka-schema-registry-kafka --namespace zilla-http-kafka-schema-registry
kubectl delete namespace zilla-http-kafka-schema-registry
