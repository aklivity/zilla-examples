#!/bin/bash
set -x

# Stop port forwarding
pgrep kubectl && killall kubectl

# Uninstall Zilla and Grpc Echo
NAMESPACE=zilla-grpc-proxy
kubectl delete namespace $NAMESPACE --force --grace-period=0
