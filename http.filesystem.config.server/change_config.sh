#!/bin/bash
set -ex

# change configfile
ZILLA_POD=$(kubectl get pods --namespace zilla-config-server --selector app.kubernetes.io/instance=zilla-config -o json | jq -r '.items[0].metadata.name')
kubectl cp --namespace zilla-config-server zilla_changed.yaml "$ZILLA_POD:/var/www/zilla.yaml"

# Start port forwarding
kubectl port-forward --namespace zilla-config-server service/zilla-http 8088 > /tmp/kubectl-zilla-config-change.log 2>&1 &
until nc -z localhost 8088; do sleep 1; done
