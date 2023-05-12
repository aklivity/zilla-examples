#!/bin/bash
set -x

# Stop port forwarding
pgrep kubectl && killall kubectl

# Uninstall Zilla & Kafka
helm uninstall zilla-http-kafka-oneway zilla-http-kafka-oneway-kafka --namespace zilla-http-kafka-oneway
kubectl delete namespace zilla-http-kafka-oneway
