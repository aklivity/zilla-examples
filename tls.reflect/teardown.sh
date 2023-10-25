#!/bin/bash
set -x

# Stop port forwarding
pgrep kubectl && killall kubectl

# Uninstall Zilla engine
NAMESPACE=zilla-tls-reflect
helm uninstall zilla --namespace $NAMESPACE
kubectl delete namespace $NAMESPACE --force --grace-period=0
