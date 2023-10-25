#!/bin/bash
set -x

# Stop port forwarding
pgrep kubectl && killall kubectl

# Uninstall Zilla and SSE Server
NAMESPACE=zilla-sse-proxy-jwt
kubectl delete namespace $NAMESPACE --force --grace-period=0
