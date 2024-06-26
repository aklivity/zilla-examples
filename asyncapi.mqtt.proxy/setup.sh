#!/bin/bash
set -ex

# Install Zilla to the Kubernetes cluster with helm and wait for the pod to start up
ZILLA_CHART="${ZILLA_CHART:-oci://ghcr.io/aklivity/charts/zilla}"
ZILLA_VERSION="${ZILLA_VERSION:-^0.9.0}"
NAMESPACE="${NAMESPACE:-asyncapi-mqtt-proxy}"
helm upgrade --install zilla $ZILLA_CHART --version $ZILLA_VERSION --namespace $NAMESPACE --create-namespace --wait \
    --values values.yaml \
    --set-file zilla\\.yaml=zilla.yaml \
    --set-file configMaps.asyncapi.data.mqtt-asyncapi\\.yaml=mqtt-asyncapi.yaml

# Install mosquitto mqtt broker to the Kubernetes cluster with helm and wait for the pod to start up
helm upgrade --install mosquitto chart --namespace $NAMESPACE --create-namespace --wait


# Start port forwarding
kubectl port-forward --namespace $NAMESPACE service/zilla 7183 > /tmp/kubectl-zilla.log 2>&1 &
kubectl port-forward --namespace $NAMESPACE service/mosquitto 1883 > /tmp/kubectl-mosquitto.log 2>&1 &
until nc -z localhost 7183; do sleep 1; done
until nc -z localhost 1883; do sleep 1; done
