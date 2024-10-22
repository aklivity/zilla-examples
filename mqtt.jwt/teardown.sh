#!/bin/sh
set -e

docker compose -p "${NAMESPACE:-zilla-asyncapi-mqtt-proxy}" down --remove-orphans
