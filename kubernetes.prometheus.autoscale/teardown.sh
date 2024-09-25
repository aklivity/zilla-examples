#!/bin/sh
set -e

# Stop port forwarding
pgrep kubectl && killall kubectl

# Uninstall Zilla, Prometheus and Prometheus Adapter
NAMESPACE="${NAMESPACE:-zilla-kubernetes-prometheus-autoscale}"
helm uninstall zilla prometheus --namespace $NAMESPACE
kubectl delete namespace $NAMESPACE
