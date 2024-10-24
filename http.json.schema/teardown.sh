#!/bin/sh
set -e

docker compose -p "${NAMESPACE:-zilla-http-json-schema}" down --remove-orphans
