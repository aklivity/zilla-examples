#!/bin/sh
set -e

docker compose -p "${NAMESPACE:-zilla-asyncapi-sse-kafka-proxy}" down --remove-orphans
