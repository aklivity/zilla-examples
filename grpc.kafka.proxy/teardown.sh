#!/bin/sh
set -e

docker compose -p "${NAMESPACE:-zilla-grpc-kafka-proxy}" down --remove-orphans
