#!/bin/sh
set -e

echo "==== Tearing down the zilla-kafka-karapace example ===="
docker compose -p zilla-kafka-karapace --profile "*" down --remove-orphans
