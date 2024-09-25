#!/bin/sh
set -e

# Start or restart Zilla
if [ -z $(docker compose ps -q zilla) ]; then
  echo "==== Running the zilla-openapi-proxy example ===="
  docker compose up -d
else
  docker compose up -d --force-recreate --no-deps zilla
fi
