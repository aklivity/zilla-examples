#!/bin/bash
set -ex

# change config file
kubectl --namespace zilla-config-server create configmap configmap-served --from-file zilla.yaml -o yaml --dry-run=client | kubectl apply -f - > /dev/null 2>&1

while [[ "$(curl -s -o -d 'Hello, World' -H 'Content-Type: text/plain' -X 'POST' /dev/null -w ''%{http_code}'' localhost:8080/echo_changed | sed 's/^0*//')" != "200" ]] > /dev/null 2>&1 ; do sleep 10 ; done
