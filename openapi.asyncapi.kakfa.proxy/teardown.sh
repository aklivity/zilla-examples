#!/bin/sh
set -e

docker compose -p "${NAMESPACE:-zilla-openapi-asyncapi-proxy}" down --remove-orphans
