#!/bin/sh
set -e

docker compose -p "${NAMESPACE:-zilla-ws-echo}" down --remove-orphans

