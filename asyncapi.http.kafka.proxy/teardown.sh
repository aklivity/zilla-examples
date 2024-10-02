#!/bin/sh
set -e

docker compose -p "${NAMESPACE:-zilla-asyncapi-http-kafka-proxy}" down --remove-orphans

