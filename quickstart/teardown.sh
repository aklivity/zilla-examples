#!/bin/sh
set -e

echo "==== Tearing down the zilla-quickstart example ===="
docker compose -p zilla-quickstart --profile "*" down --remove-orphans

