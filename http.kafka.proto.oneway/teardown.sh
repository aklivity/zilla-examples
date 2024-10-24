#!/bin/sh
set -e

docker compose -p "${NAMESPACE:-zilla-http-kafka-proto-oneway}" down --remove-orphans
