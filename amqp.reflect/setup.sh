#!/bin/bash
set -ex

docker image inspect ghcr.io/aklivity/zilla:develop-SNAPSHOT --format 'Image Found {{.RepoTags}}'

# Install Zilla to the Kubernetes cluster with helm and wait for the pod to start up
ZILLA_CHART=oci://ghcr.io/aklivity/charts/zilla
helm upgrade --install zilla-amqp-reflect $ZILLA_CHART --namespace zilla-amqp-reflect --create-namespace --wait \
    --values values.yaml \
    --set-file zilla\\.yaml=zilla.yaml \
    --set-file secrets.tls.data.localhost\\.p12=tls/localhost.p12

# Start port forwarding
kubectl port-forward --namespace zilla-amqp-reflect service/zilla-amqp-reflect 7171 7172 > /tmp/kubectl-zilla.log 2>&1 &
until nc -z localhost 7171; do sleep 1; done
