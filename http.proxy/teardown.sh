#!/bin/sh
set -e

docker compose -p "${NAMESPACE:-zilla-http-proxy}" down --remove-orphans
