#!/bin/sh
set -e

NAMESPACE="${NAMESPACE:-zilla-asyncapi-sse-kafka-proxy}"
docker compose -p $NAMESPACE down --remove-orphans
