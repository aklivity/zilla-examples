#!/bin/sh
set -e

docker compose -p "${NAMESPACE:-zilla-http-schema-validate}" down --remove-orphans

