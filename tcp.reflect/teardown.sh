#!/bin/bash
set -x

# Stop port forwarding
pgrep kubectl && killall kubectl

# Uninstall Zilla engine
NAMESPACE=zilla-tcp-reflect
kubectl delete namespace $NAMESPACE --force --grace-period=0
