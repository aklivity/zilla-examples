#!/bin/sh
set -e

docker compose -p "${NAMESPACE:-zilla-grpc-echo}" down --remove-orphans

