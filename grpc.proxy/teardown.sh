#!/bin/sh
set -e

docker compose -p "${NAMESPACE:-zilla-grpc-proxy}" down --remove-orphans

