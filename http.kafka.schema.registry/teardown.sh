#!/bin/sh
set -e

docker compose -p "${NAMESPACE:-zilla-http-kafka-schema-registry}" down --remove-orphans

