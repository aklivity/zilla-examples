#!/bin/sh
set -e

NAMESPACE="${NAMESPACE:-zilla-openapi-asyncapi-proxy}"
docker compose -p $NAMESPACE down --remove-orphans
