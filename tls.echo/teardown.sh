#!/bin/sh
set -e

docker compose -p "${NAMESPACE:-zilla-tls-echo}" down --remove-orphans

