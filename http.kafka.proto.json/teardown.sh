#!/bin/sh
set -e

docker compose -p "${NAMESPACE:-zilla-http-kafka-proto-json}" down --remove-orphans
