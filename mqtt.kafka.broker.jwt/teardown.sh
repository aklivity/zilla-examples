#!/bin/sh
set -e

docker compose -p "${NAMESPACE:-zilla-mqtt-kafka-broker-jwt}" down --remove-orphans

