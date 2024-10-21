#!/bin/sh
set -e

docker compose -p "${NAMESPACE:-zilla-sse-proxy-jwt}" down --remove-orphans

