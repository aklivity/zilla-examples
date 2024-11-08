#!/bin/sh
set -e

docker compose -p "${NAMESPACE:-zilla-mqtt-proxy}" down --remove-orphans
