#!/bin/sh
set -e

docker compose -p "${NAMESPACE:-zilla-http-jwt}" down --remove-orphans
