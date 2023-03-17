#!/bin/bash
set -ex

# Install Zilla to the Kubernetes cluster with helm and wait for the pod to start up
helm install zilla-grpc-proxy chart --namespace zilla-grpc-proxy --create-namespace --wait --debug --timeout 2m

# Start port forwarding
kubectl port-forward --namespace zilla-grpc-echo service/zilla 9000 > /tmp/kubectl-zilla.log 2>&1 &
kubectl port-forward --namespace zilla-grpc-echo service/zilla 9090 > /tmp/kubectl-zilla.log 2>&1 &
until nc -z localhost 9000; do sleep 1; done
until nc -z localhost 9090; do sleep 1; done


helm install zilla-grpc-proxy --namespace zilla-grpc-proxy -f
