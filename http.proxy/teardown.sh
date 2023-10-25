#!/bin/bash
set -x

# Stop port forwarding
pgrep kubectl && killall kubectl

# Uninstall Zilla and Nginx
NAMESPACE=zilla-http-proxy
kubectl delete namespace $NAMESPACE --force --grace-period=0
