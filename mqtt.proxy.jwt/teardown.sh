#!/bin/sh
set -e

docker compose -p "${NAMESPACE:-zilla-mqtt-proxy-jwt}" down --remove-orphans
