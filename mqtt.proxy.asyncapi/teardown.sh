#!/bin/bash
set -x

# Stop port forwarding
pgrep kubectl && killall kubectl

# Uninstall Zilla and mosquitto
NAMESPACE=mqtt-proxy-asyncapi
kubectl delete namespace $NAMESPACE --force --grace-period=0
