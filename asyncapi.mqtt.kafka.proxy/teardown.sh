#!/bin/sh
set -e

docker compose -p "${NAMESPACE:-zilla-asyncapi-mqtt-kafka-proxy}" down --remove-orphans
