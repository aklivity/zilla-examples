#!/bin/bash
set -x

# Stop port forwarding
pgrep kubectl && killall kubectl

# Uninstall Zilla & Kafka
helm uninstall zilla-http-kafka-crud zilla-http-kafka-crud-kafka --namespace zilla-http-kafka-crud
kubectl delete namespace zilla-http-kafka-crud
