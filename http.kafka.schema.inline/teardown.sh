#!/bin/bash
set -x

# Stop port forwarding
pgrep kubectl && killall kubectl

# Uninstall Zilla and Kafka
helm uninstall zilla-http-kafka-schema-inline zilla-http-kafka-schema-inline-kafka --namespace zilla-http-kafka-schema-inline
kubectl delete namespace zilla-http-kafka-schema-inline
