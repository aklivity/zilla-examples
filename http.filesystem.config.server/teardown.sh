#!/bin/sh
set -e

docker compose -p "${NAMESPACE:-zilla-http-filesystem-config-server}" down --remove-orphans

