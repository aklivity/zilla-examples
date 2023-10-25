#!/bin/bash
set -x

# Stop port forwarding
pgrep kubectl && killall kubectl

# Uninstall Zilla and Kafka
NAMESPACE=zilla-grpc-kafka-fanout
kubectl delete namespace $NAMESPACE --force --grace-period=0
