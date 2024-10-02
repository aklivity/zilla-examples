#!/bin/sh
set -e

docker compose -p "${NAMESPACE:-zilla-http-kafka-sasl-scram}" down --remove-orphans

