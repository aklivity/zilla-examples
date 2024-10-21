#!/bin/sh
set -e

docker compose -p "${NAMESPACE:-zilla-grpc-kafka-fanout}" down --remove-orphans

