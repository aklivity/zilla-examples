#!/bin/bash
set -e

export ZILLA_VERSION="${ZILLA_VERSION:-latest}"
export KAFKA_VENDOR_PROFILE="${KAFKA_VENDOR_PROFILE:-bitnami}"
export KAFKA_BOOTSTRAP_SERVER="${KAFKA_BOOTSTRAP_SERVER:-host.docker.internal:9092}"
COMPOSE_PROFILES="$KAFKA_VENDOR_PROFILE"
INIT_KAFKA="${INIT_KAFKA:-true}"
[[ $INIT_KAFKA == true ]] && COMPOSE_PROFILES="$KAFKA_VENDOR_PROFILE,init-$KAFKA_VENDOR_PROFILE"
export COMPOSE_PROFILES

# Start or restart Zilla
if [[ -z $(docker compose -p "zilla-quickstart" ps -q zilla) ]]; then
  echo "==== Running the zilla-quickstart example with $KAFKA_VENDOR_PROFILE($KAFKA_BOOTSTRAP_SERVER) with profiles ($COMPOSE_PROFILES) ===="
  docker compose up -d
else
  docker compose up -d --force-recreate --no-deps zilla
fi
