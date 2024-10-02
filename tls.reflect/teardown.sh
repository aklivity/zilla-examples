#!/bin/sh
set -e

docker compose -p "${NAMESPACE:-zilla-tls-reflect}" down --remove-orphans

