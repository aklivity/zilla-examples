#!/bin/bash
set -ex

# Install Zilla to the Kubernetes cluster with helm and wait for the pod to start up
ZILLA_CHART=oci://ghcr.io/aklivity/charts/zilla
VERSION=0.9.45
helm install zilla-http-echo-jwt $ZILLA_CHART --version $VERSION --namespace zilla-http-echo-jwt --create-namespace --wait \
    --values values.yaml \
    --set-file zilla\\.yaml=zilla.yaml \
    --set-file secrets.tls.data.localhost\\.p12=tls/localhost.p12

# Start port forwarding
kubectl port-forward --namespace zilla-http-echo-jwt service/zilla-http-echo-jwt 8080 9090 > /tmp/kubectl-zilla.log 2>&1 &
until nc -z localhost 8080; do sleep 1; done
