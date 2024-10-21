#!/bin/sh
set -e

docker compose -p "${NAMESPACE:-zilla-mqtt-kafka-broker}" down --remove-orphans

