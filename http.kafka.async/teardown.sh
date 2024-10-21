#!/bin/sh
set -e

docker compose -p "${NAMESPACE:-zilla-http-kafka-async}" down --remove-orphans

