#!/bin/sh
set -e

docker compose -p "${NAMESPACE:-zilla-openapi-proxy}" down --remove-orphans

