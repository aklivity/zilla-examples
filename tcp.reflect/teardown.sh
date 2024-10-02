#!/bin/sh
set -e

docker compose -p "${NAMESPACE:-zilla-tcp-reflect}" down --remove-orphans

