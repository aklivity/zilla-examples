#!/bin/sh
set -e

docker compose -p "${NAMESPACE:-zilla-http-proxy-jwt}" down --remove-orphans
