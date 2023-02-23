#!/bin/bash
set -ex

# Install Zilla to the Kubernetes cluster with helm and wait for the pod to start up
helm install zilla-config-server chart --namespace zilla-config-server --create-namespace --wait

# Start port forwarding
kubectl port-forward --namespace zilla-config-server service/zilla-config 8081 9091 > /tmp/kubectl-zilla-config.log 2>&1 &
kubectl port-forward --namespace zilla-config-server service/zilla-http 8080 9090 > /tmp/kubectl-zilla-http.log 2>&1 &
until nc -z localhost 8081; do sleep 1; done
until nc -z localhost 8080; do sleep 1; done
