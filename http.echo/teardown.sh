#!/bin/sh
set -e

docker compose -p "${NAMESPACE:-zilla-http-echo}" down --remove-orphans

