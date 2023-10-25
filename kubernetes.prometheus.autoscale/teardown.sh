#!/bin/bash
set -x

# Stop port forwarding
pgrep kubectl && killall kubectl

# Uninstall Zilla, Prometheus and Prometheus Adapter
NAMESPACE=zilla-kubernetes-prometheus-autoscale
kubectl delete namespace $NAMESPACE --force --grace-period=0
