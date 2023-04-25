#!/bin/bash
set -ex

# Install Zilla to the Kubernetes cluster with helm and wait for the pod to start up
helm install zilla-autoscaling chart --namespace zilla-autoscaling --create-namespace --wait

# Start port forwarding
kubectl port-forward --namespace zilla-autoscaling service/zilla 8080 > /tmp/kubectl-zilla.log 2>&1 &
kubectl port-forward --namespace zilla-autoscaling service/prometheus 9090 > /tmp/kubectl-prometheus.log 2>&1 &
until nc -z localhost 8080; do sleep 1; done
until nc -z localhost 9090; do sleep 1; done