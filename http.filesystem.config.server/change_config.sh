#!/bin/bash
set -ex

# change config file
kubectl --namespace zilla-config-server create configmap zilla-served --from-file zilla.yaml -o yaml --dry-run=client | kubectl apply -f - > /dev/null 2>&1

until curl -s -f -d 'Hello, World' -H 'Content-Type: text/plain' -X 'POST' -v http://localhost:8080/echo_changed > /dev/null 2>&1 ; do sleep 10 ; done
