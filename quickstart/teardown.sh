#!/bin/sh
set -e

docker compose -p "${NAMESPACE:-zilla-quickstart}" down --remove-orphans

