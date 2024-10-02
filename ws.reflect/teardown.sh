#!/bin/sh
set -e

docker compose -p "${NAMESPACE:-zilla-ws-reflect}" down --remove-orphans

