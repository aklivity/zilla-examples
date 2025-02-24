#!/bin/sh
set -e

docker compose -p "${NAMESPACE:-zilla-mqtt-jwt}" down --remove-orphans
