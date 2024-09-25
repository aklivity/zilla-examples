#!/bin/sh
set -e

echo "==== Tearing down the zilla-http-kafka-sync example ===="
docker compose -p zilla-http-kafka-sync --profile "*" down --remove-orphans

