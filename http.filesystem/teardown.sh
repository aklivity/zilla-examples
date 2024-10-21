#!/bin/sh
set -e

docker compose -p "${NAMESPACE:-zilla-http-filesystem}" down --remove-orphans

