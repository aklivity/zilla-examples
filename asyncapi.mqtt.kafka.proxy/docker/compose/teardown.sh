#!/bin/sh
set -e

NAMESPACE="${NAMESPACE:-zilla-asyncapi-mqtt-kafka-proxy}"
docker compose -p $NAMESPACE down --remove-orphans
