#!/bin/sh
set -e

docker compose -p "${NAMESPACE:-zilla-http-redpanda-sasl-scram}" down --remove-orphans

