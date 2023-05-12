#!/bin/bash
set -ex

# Install Zilla to the Kubernetes cluster with helm and wait for the pod to start up
ZILLA_CHART=../zilla-0.1.0-develop-SNAPSHOT.tgz
helm install zilla-mqtt-reflect $ZILLA_CHART --namespace zilla-mqtt-reflect --create-namespace --wait \
    --values values.yaml \
    --set-file zilla\\.yaml=zilla.yaml \
    --set-file secrets.tls.data.localhost\\.p12=tls/localhost.p12

# Start port forwarding
kubectl port-forward --namespace zilla-mqtt-reflect service/zilla-mqtt-reflect 1883 8883 > /tmp/kubectl-zilla.log 2>&1 &
until nc -z localhost 1883; do sleep 1; done
