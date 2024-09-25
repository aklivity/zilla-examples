#!/bin/sh
set -e

NAMESPACE="${NAMESPACE:-zilla-asyncapi-http-kafka-proxy}"
docker compose -p $NAMESPACE down --remove-orphans
