#!/bin/bash
set -x

# Stop port forwarding
pgrep kubectl && killall kubectl

# Uninstall Zilla and Redpanda
NAMESPACE=zilla-http-redpanda-sasl-scram
kubectl delete namespace $NAMESPACE --force --grace-period=0
