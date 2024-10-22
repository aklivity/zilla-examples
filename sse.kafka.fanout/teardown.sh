#!/bin/sh
set -e

docker compose -p "${NAMESPACE:-zilla-sse-kafka-fanout}" down --remove-orphans
