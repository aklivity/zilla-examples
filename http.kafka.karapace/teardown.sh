#!/bin/sh
set -e

docker compose -p "${NAMESPACE:-zilla-http-kafka-karapace}" down --remove-orphans

