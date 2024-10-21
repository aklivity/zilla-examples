#!/bin/sh
set -e

docker compose -p "${NAMESPACE:-zilla-http-kafka-sync}" down --remove-orphans

