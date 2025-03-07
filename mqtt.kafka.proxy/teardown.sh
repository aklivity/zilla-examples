#!/bin/sh
set -e

docker compose -p "${NAMESPACE:-zilla-mqtt-kafka-proxy}" down --remove-orphans
