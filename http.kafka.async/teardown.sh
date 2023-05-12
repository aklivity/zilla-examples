#!/bin/bash
set -x

# Stop port forwarding
pgrep kubectl && killall kubectl

# Uninstall Zilla & Kafka
helm uninstall zilla-http-kafka-async zilla-http-kafka-async-kafka --namespace zilla-http-kafka-async
kubectl delete namespace zilla-http-kafka-async
