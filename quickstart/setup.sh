#!/bin/sh
set -e

export KAFKA_VENDOR_PROFILE="${KAFKA_VENDOR_PROFILE:-bitnami}"
COMPOSE_PROFILES="$KAFKA_VENDOR_PROFILE"
INIT_KAFKA="${INIT_KAFKA:-true}"
REMOTE_KAFKA="${REMOTE_KAFKA:-false}"
! [ $REMOTE_KAFKA = true ] && COMPOSE_PROFILES="$KAFKA_VENDOR_PROFILE"
[ $INIT_KAFKA = true ] && COMPOSE_PROFILES="$COMPOSE_PROFILES,$KAFKA_VENDOR_PROFILE-init"
export COMPOSE_PROFILES

# Start or restart Zilla
if [ -z $(docker compose -p "zilla-quickstart" ps -q zilla) ]; then
  echo "==== Running the zilla-quickstart example with $KAFKA_VENDOR_PROFILE($KAFKA_BOOTSTRAP_SERVER) with profiles ($COMPOSE_PROFILES) ===="
  docker compose up -d
else
  docker compose up -d --force-recreate --no-deps zilla
fi
