#!/bin/sh
set -e

docker compose -p "${NAMESPACE:-zilla-http-echo-jwt}" down --remove-orphans

