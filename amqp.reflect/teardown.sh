#!/bin/sh
set -e

docker compose -p "${NAMESPACE:-zilla-amqp-reflect}" down --remove-orphans
