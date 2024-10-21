#!/bin/sh
set -e

docker compose -p "${NAMESPACE:-zilla-asyncapi-sse-proxy}" down --remove-orphans

