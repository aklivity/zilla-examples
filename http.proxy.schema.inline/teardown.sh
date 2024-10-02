#!/bin/sh
set -e

docker compose -p "${NAMESPACE:-zilla-http-proxy-schema-inline}" down --remove-orphans

