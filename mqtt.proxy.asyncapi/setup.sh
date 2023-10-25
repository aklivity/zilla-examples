#!/bin/bash
set -ex

docker image inspect ghcr.io/aklivity/zilla:develop-SNAPSHOT --format 'Image Found {{.RepoTags}}'

# Install Zilla to the Kubernetes cluster with helm and wait for the pod to start up
ZILLA_CHART=oci://ghcr.io/aklivity/charts/zilla
helm upgrade --install mqtt-proxy-asyncapi $ZILLA_CHART --namespace mqtt-proxy-asyncapi --create-namespace --wait \
    --values values.yaml \
    --set-file zilla\\.yaml=zilla.yaml

# Install mosquitto mqtt broker to the Kubernetes cluster with helm and wait for the pod to start up
helm upgrade --install mqtt-proxy-asyncapi-mosquitto chart --namespace mqtt-proxy-asyncapi --create-namespace --wait


# Start port forwarding
kubectl port-forward --namespace mqtt-proxy-asyncapi service/mqtt-proxy-asyncapi-zilla 7183 > /tmp/kubectl-zilla.log 2>&1 &
kubectl port-forward --namespace mqtt-proxy-asyncapi service/mosquitto 7184 > /tmp/kubectl-mosquitto.log 2>&1 &
until nc -z localhost 7183; do sleep 1; done
until nc -z localhost 7184; do sleep 1; done
