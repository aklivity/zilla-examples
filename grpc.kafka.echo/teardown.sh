#!/bin/sh
set -e

docker compose -p "${NAMESPACE:-zilla-grpc-kafka-echo}" down --remove-orphans
