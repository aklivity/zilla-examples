#!/bin/bash
set -x

# Stop port forwarding
pgrep kubectl && killall kubectl

# Uninstall Zilla engine
helm uninstall zilla-autoscaling --namespace zilla-autoscaling
kubectl delete namespace zilla-autoscaling
