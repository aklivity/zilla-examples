#!/bin/sh
set -e

docker compose -p "${NAMESPACE:-zilla-http-kafka-proto}" down --remove-orphans
