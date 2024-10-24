#!/bin/sh
set -e

docker compose -p "${NAMESPACE:-zilla-http-kafka-crud}" down --remove-orphans
